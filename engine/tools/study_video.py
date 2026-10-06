#!/usr/bin/env python3
"""Measure a reference video and make the three images used to study it.

    python3 study_video.py <video.mp4> [out_dir] [--cap 240]

Writes into out_dir (default: next to the video, in <name>-study/):
  metrics.json  duration, size, fps, audio, moving %, longest still, cuts, cut times,
                median shot, cuts per minute, integrated loudness (EBU R128)
  sheet.jpg     16 frames, 4x4 row-major; tile k is the exact frame at (k+0.5)*T/16
  hook.jpg      the first 2.5s: 6 frames at 0, 0.5, 1.0, 1.5, 2.0 and 2.5s
  end.jpg       the last 4s: 6 frames at 4.0, 3.2, 2.4, 1.6, 0.8 and 0.25s before the end

The moving % uses the same metric as references/qa.md 2.3 (30fps, 160x90 grey, a frame
pair is still when its mean absolute difference is below 0.15), so numbers compare with
her cuts and with references/video-study.md. Cut detection (scene > 0.32) misses morphs,
dissolves, dark cuts and cuts inside split screens, and over-counts stepped redraws.

Every sheet frame comes from its own seek. Do not sample with select='lt(abs(t-X),0.02)':
at 60fps that window keeps 2-3 frames per target and the 16 tiles end near 40% of the
video; at 24fps it can miss targets (found 2026-10-06). A plain fps=N/D filter with no
-ss is also correct (tile k lands at (k+0.5)*D/N); adding -ss on top shifts it.
Needs only ffmpeg and ffprobe: the bundled pair in Cardboard.app, or any on PATH.
"""
import json, os, re, shutil, subprocess, sys, tempfile

BUNDLE = '/Applications/Cardboard.app/Contents/Resources/bin'
FF = os.path.join(BUNDLE, 'ffmpeg') if os.path.exists(os.path.join(BUNDLE, 'ffmpeg')) else 'ffmpeg'
FP = os.path.join(BUNDLE, 'ffprobe') if os.path.exists(os.path.join(BUNDLE, 'ffprobe')) else 'ffprobe'


def run(cmd):
    return subprocess.run(cmd, capture_output=True, text=True)


def grab(video, t, png, from_end=False):
    seek = ['-sseof', f'-{t:.3f}'] if from_end else ['-ss', f'{t:.3f}']
    run([FF, '-v', 'error', '-y'] + seek + ['-i', video, '-frames:v', '1', '-vf', 'scale=480:-2', png])
    return os.path.exists(png)


def tile(frames_dir, cols, rows, out):
    run([FF, '-v', 'error', '-y', '-framerate', '1', '-i', os.path.join(frames_dir, 'f%02d.png'),
         '-vf', f'tile={cols}x{rows}:padding=4:color=white', '-frames:v', '1', out])


def study(video, out_dir, cap=240.0):
    os.makedirs(out_dir, exist_ok=True)
    p = json.loads(run([FP, '-v', 'error', '-show_entries',
                        'format=duration:stream=codec_type,width,height,r_frame_rate', '-of', 'json', video]).stdout)
    vs = [s for s in p['streams'] if s.get('codec_type') == 'video'][0]
    a, b = vs['r_frame_rate'].split('/')
    m = {'file': os.path.basename(video), 'dur': float(p['format']['duration']), 'w': vs['width'], 'h': vs['height'],
         'fps': round(float(a) / float(b), 2), 'audio': any(s.get('codec_type') == 'audio' for s in p['streams'])}
    T = min(m['dur'], cap)
    m['measured_s'] = round(T, 2)

    tmp = tempfile.mkdtemp()
    try:
        mot = os.path.join(tmp, 'motion.txt')
        fc = (f"[0:v]split=2[a][b];"
              f"[a]fps=30,scale=160:90,format=gray,tblend=all_mode=difference,signalstats,"
              f"metadata=print:key=lavfi.signalstats.YAVG:file={mot},nullsink;"
              f"[b]scale=320:-2,select='gt(scene,0.32)',showinfo,nullsink")
        cmd = [FF, '-v', 'info', '-t', f'{T:.3f}', '-i', video, '-filter_complex', fc]
        cmd += (['-map', '0:a:0', '-af', 'ebur128', '-f', 'null', '-'] if m['audio'] else ['-f', 'null', '-'])
        r = run(cmd)
        ys = [float(x) for x in re.findall(r'YAVG=([0-9.]+)', open(mot).read())] if os.path.exists(mot) else []
        if ys:
            moving = [y >= 0.15 for y in ys]
            m['moving_pct'] = round(100 * sum(moving) / len(moving), 1)
            run_, best = 0, 0
            for x in moving:
                run_ = 0 if x else run_ + 1
                best = max(best, run_)
            m['longest_still_s'] = round(best / 30, 2)
        cuts = [float(x) for x in re.findall(r'pts_time:([0-9.]+)', r.stderr)]
        m['cuts'] = len(cuts)
        m['cut_times'] = [round(c, 2) for c in cuts[:120]]
        shots = sorted(s for s in (y - x for x, y in zip([0] + cuts, cuts + [T])) if s > 0.05)
        m['median_shot_s'] = round(shots[len(shots) // 2], 2) if shots else None
        m['cuts_per_min'] = round(len(cuts) / (T / 60), 1) if T > 0 else None
        if m['audio']:
            loud = re.findall(r'I:\s+(-?[0-9.]+) LUFS', r.stderr)
            m['lufs'] = float(loud[-1]) if loud else None

        for name, times, from_end, cols, rows in (
                ('sheet', [(k + 0.5) * T / 16 for k in range(16)], False, 4, 4),
                ('hook', [0.0, 0.5, 1.0, 1.5, 2.0, 2.5], False, 6, 1),
                ('end', [4.0, 3.2, 2.4, 1.6, 0.8, 0.25], True, 3, 2)):
            d = os.path.join(tmp, name)
            os.makedirs(d)
            for i, t in enumerate(times):
                png = os.path.join(d, f'f{i:02d}.png')
                for back in (0.0, 0.5, 1.0, 2.0):   # a seek past the last video frame returns nothing
                    if grab(video, t + back if from_end else max(t - back, 0), png, from_end):
                        break
            tile(d, cols, rows, os.path.join(out_dir, f'{name}.jpg'))
    finally:
        shutil.rmtree(tmp)
    json.dump(m, open(os.path.join(out_dir, 'metrics.json'), 'w'), indent=1)
    return m


if __name__ == '__main__':
    args = [x for x in sys.argv[1:] if not x.startswith('--')]
    cap = float(sys.argv[sys.argv.index('--cap') + 1]) if '--cap' in sys.argv else 240.0
    if cap in [float(x) for x in args[1:] if re.fullmatch(r'[0-9.]+', x)]:
        args = [x for x in args if x != sys.argv[sys.argv.index('--cap') + 1]]
    if not args:
        sys.exit(__doc__)
    video = args[0]
    out = args[1] if len(args) > 1 else os.path.splitext(video)[0] + '-study'
    print(json.dumps(study(video, out, cap), indent=1))
