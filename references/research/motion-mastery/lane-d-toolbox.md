# Lane D: the toolbox on this Mac (no installs)

**Date:** 2026-10-15.

**Question:** what can be rendered here, with nothing installed, that the films have not used yet?

**Answer in one line:** real 3D (raymarched signed distance fields on the M5 GPU), 247 CoreImage filters, 180 font families, and a renderer that can draw the same scene in any medium.

**How it was checked:**
- probes in `toolbox/probe.swift`;
- the GPU harness in `~/.claude/skills/video-master/engine/gpu/`;
- the media reel built on it (`reports/videos/media-reel-src/`).

Every claim here was run on this Mac on this date.

## 1. Metal compute, compiled at runtime

**What it is.** A `.metal` source file is compiled when the program starts (`device.makeLibrary(source:)`), so no Xcode project and no `metallib` build step are needed. A compute kernel writes one pixel per thread into an `rgba16Float` texture. The driver reads it back, converts it to BGRA with a 4x4 ordered dither, and pipes it to the bundled ffmpeg.

**Speed on the M5** (1920x1080, 2x2 supersampling, a scene with soft shadows, ambient occlusion and a floor reflection):
- 0.15 to 0.25s a frame;
- about 0.6s with 5 motion-blur subframes;
- 0.3s for the infinity-mirror medium (up to 16 reflections).

**Harnesses:**
- `engine/gpu/gpu.swift`: one shader, stills or raw frames.
- `reports/videos/media-reel-src/reel.swift`: several kernels, extra textures, CoreImage post and CoreText type in one program.

**Gotchas:**
- **Basis.** Use `rt = normalize(cross(fw, up))` and `up = cross(rt, fw)`. The other order mirrors the picture.
- **Struct layout.** Keep uniforms in `float4` blocks. Swift's `SIMD4<Float>` matches Metal's alignment; mixed `float3` fields do not.
- **No derivatives.** Compute kernels have no `dfdx`. Estimate a pixel's footprint on a surface as `t / (resY * focal) / |dot(n, rd)|` and use it to antialias lines and pick mip levels.

## 2. Signed distance fields and real 3D

**Raymarching.** Sphere tracing a signed distance function (SDF) gives real 3D with no meshes:
- soft shadows (`k * h / t`);
- ambient occlusion (five samples along the normal);
- reflections (trace again from the hit);
- haze in a light beam (march the view ray and test the sun's gobo at each step);
- depth of field (jitter the ray origin on a lens disk).

**The mark in 3D.**
- `markfield.swift` turns the exact vector path of the supermemory mark (`apps/docs/images/supermemory.svg`) into an exact signed distance field: 1024², mark units, inside negative.
- The shader extrudes it: `max(d2D, |z| - depth)`, with rounded edges.
- An EDT of a pixel mask (`engine/gpu/sdfgen.swift`) also works, but leaves stair-step ribs on the 45° faces under raking light. Use the vector path whenever one exists.

**Gobo light.** A mullioned window is a function, not geometry: project the point along the sun onto the window plane and test the panes, with a penumbra that grows with distance. It is cheap, and it moves when the sun moves.

**Anamorphic paint (after Felice Varini).**
- Project any surface point through a chosen camera.
- Sample a screen-space "slide".
- Paint only where that camera can see the point (march a visibility ray).
- From that one viewpoint, the paint on walls, floor and corners lines up into flat graphics; from anywhere else it breaks apart.
- This is how the media reel's wordmark joins the 3D mark into the official lockup.

**Infinity mirrors (after Yayoi Kusama).** Replace walls with mirrors and keep reflecting. Darken a little per bounce, and fade the distance into white fog so infinity reads as light rather than a black hole.

## 3. One scene, many media

Shading is just a function of what the ray hit. So the same geometry and light can be drawn as:

| Medium | How | Key parameters |
|---|---|---|
| Light (photographic) | soft shadows, AO, bounce, glossy floor, haze, ACES curve, grain, CIBloom | sun 3.1, sky 0.62, bloom radius 18, intensity 0.2 |
| Engraving | parallel lines in a coordinate that follows each surface. The line weight carries the tone; a second family appears only in shade, a third in deep shade. Contours come from the geometry itself (distance to the face's edges) | 56 lines/m; families start at darkness 0.06, 0.50 and 0.75; a thin line covers at most its own width |
| Type (ASCII) | a `cells` kernel renders 4x4 rays per cell: tone, colour, edge angle (PCA of the discontinuities), share of sculpture. CoreText then sets Geist Mono glyphs: the sculpture in its own name, edges as `- \ | /`, a sparse ramp for the room | 15x28px cells at 1080p; type steps at 15fps |
| Survey | iso-height lines on the sculpture, iso-distance rings (distance to the sculpture) on the room, faint hillshade | minor contours 0.022 m (sculpture) and 0.045 m (room), with every fifth line heavier |
| Risograph | two plates sampled through their own misregistration, clustered-dot screens at 15° and 75°, ink blotch noise, paper tooth, 12fps | cell 9.5px, misregistration 2.6px, blue plate for form, pink plate for sunlight |
| Mirror room | the walls become mirrors | 16 bounces, 0.93 a bounce, white fog |

## 4. CoreImage (247 filters on this Mac)

**Most useful for films:**
- **Light and lens:** CIBloom, CIGloom, CIBokehBlur, CIDepthOfField (a fake), CIMotionBlur, CIZoomBlur, CIDiscBlur.
- **Print and texture:** CICMYKHalftone, CIDotScreen, CILineScreen, CIHatchedScreen, CICircularScreen, CIDither, CIPalettize, CIColorMap, CIRandomGenerator (grain).
- **Geometry:**
  - CIDroste: Escher's Print Gallery spiral. It was tested on the gallery frame and reads as a generic tunnel filter unless the inset is a real frame in the picture.
  - Also: CIKaleidoscope, CILightTunnel, CITorusLensDistortion, CIDisplacementDistortion, CIGlassDistortion.
- **Transitions:** CIPageCurlTransition, CIDisintegrateWithMaskTransition, CICopyMachineTransition, CIModTransition, CIRippleTransition, CIAccordionFoldTransition, CIBarsSwipeTransition.
- **Shape:**
  - CIHeightFieldFromMask with CIShadedMaterial: emboss text into a material.
  - CISignedDistanceGradientFromRedMask.
  - CIPersonSegmentation: Vision mattes, though unreliable on back views and blur.

**Gotcha.** Hand CoreImage a `clampedToExtent()` image before any blur or bloom, then crop back, or the frame edges darken.

## 5. Type

The Mac carries 180 font families. The brand faces are Geist and Geist Mono, which live in each film's `fonts/`.

For editorial work, use their PostScript names (CTFontCreateWithName returns Helvetica silently on a wrong name):

| Family | PostScript names |
|---|---|
| Didot | Didot, Didot-Italic, Didot-Bold |
| Bodoni 72 | BodoniSvtyTwoITCTT-Book, -BookIta, -Bold; Oldstyle: BodoniSvtyTwoOSITCTT-*; Smallcaps: BodoniSvtyTwoSCITCTT-Book |
| Big Caslon | BigCaslon-Medium |
| Hoefler Text | HoeflerText-Regular, -Italic, -Black |
| Baskerville | Baskerville, -Italic, -SemiBold |
| Iowan Old Style | IowanOldStyle-Roman, -Italic, -Titling |
| Superclarendon | Superclarendon-Light … -Black |
| STIX Two Text | STIXTwoText, STIXTwoText-Italic |
| Futura | Futura-Medium, Futura-CondensedExtraBold |
| DIN | DINCondensed-Bold, DINAlternate-Bold |
| Avenir Next Condensed | AvenirNextCondensed-UltraLight … -Heavy |
| Mono | Menlo, Andale Mono, PT Mono, Courier New |

**Brand guard.** supermemory's words stay in Geist (the brand book). A serif can carry an editorial accent or a medium, never the brand's own lines, unless she asks.

## 6. Sound

GarageBand's Apple Loops are licensed for your own soundtracks.

**Reading the metadata.** The CAF metadata gives `beat count`, `key signature` and `key type`. Tempo = beats ÷ duration × 60. Read it with Python (`re` on the raw bytes); `strings` piped through zsh `echo` mangles it.

**Kits by pack:**
- **Chillwave (07):** whole kits at 100 BPM with matched keys, such as Chill Melody (E major), Icy Crystals (A minor) and Kyoto Night (B minor), plus nine beats at 100 BPM.
- **Modern RnB (04):** its 126 BPM loops are in mixed keys (Gb, Bb, A). They need transposing (`asetrate` + `atempo`) to play together.
- **Indie Disco (08) and Electro House (02):** at 125 BPM.

**Decoding.** Decode to `~/Library/Caches/video-master/loops` and skip the 2112-sample AAC priming.

## 7. What did not work

- **CIDroste** as a climax: a filter look, and the mark gets lost. It was replaced by real mirrors.
- **Hairline aliasing.** An antialiased line of zero width still drew a 1px hairline (`clamp((w - d)/fw + 0.5)`), which showed every hatch family everywhere. Multiply by `min(1, 2w/fw)`.
- **The haze range.** Marching only the first 9m missed the beam from a far camera. March the whole ray, up to 22m.
- **The 3D wordmark hiding too early.** Hiding it by camera framing alone pushed the sculpture to the frame edge. Painting it on during the final move frees the framing.
