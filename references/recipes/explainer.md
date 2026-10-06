# Recipe: explainer

A film that explains how one thing works. It runs 27 to 80s for social, and much longer for essay-style pieces. 10 of 156 in the set.

**Use it when** the mechanism is the subject.

**On supermemory** her explainer rules lead:
- `references/story.md`, problem first;
- the 16:9 frame with a text column and a figure stage;
- statements at ink 45% with the key words in full ink;
- 25 to 30s unless comprehension needs more (SKILL.md section 1).

This recipe adds what the bookmarked explainers do well.

## Targets (10 explainers, medians)

| Measure | Median | Use |
|---|---|---|
| Length | 65s | 25 to 30s for her 16:9 cuts; 60 to 70s only for a full mechanism |
| Moving | 50% | 60%+ (her rule). The set moves least of any format here, and its slow builds are where viewers drop |
| Longest still | 2.6s | about 1s before the end card |
| Cuts per minute | 0 | Continuous builds; every explainer here except the talking ones has no detected cut |
| Loudness | -16.1 LUFS | -14 when scored |

## Beat template: 30s

| Time | Beat | What happens |
|---|---|---|
| 0 to 1s | The question | A question a non-expert can answer in their head, blurred in word by word and complete by 1s (1#9). Or the messy real-world input at frame 0: a noisy waveform in a noisy bar (1#8) |
| 1 to 6s | The wrong model | Strike through the mental model most people hold before showing the right one ("melody" in 1#8) |
| 6 to 20s | The mechanism | **One object persists and transforms**: waveform to spectrogram to peaks (1#8). Each beat names exactly one idea. The accent marks only what matters. Use progressive reduction: all the messy data, then only the few points that matter |
| 20 to 26s | Proof | One real example run through the mechanism, with its source on screen |
| 26 to 30s | Close | A quotable contrast of two numbers ("90 years. 4 days.", 1#9) with a sources line on the last card, then the lockup |

## Moves that make it

- **An analogy morph:** a familiar object turns into the technical one in one continuous move (1#9). On supermemory, a person remembering becomes agent memory.
- **One primitive that changes meaning** each beat: a dot is users, then drop-off, then money (1#25).
- **Two registers of one subject,** alternating every 1 to 2s: a scene view and a blueprint view (3#2).
- **Pipeline as objects:** pages, then highlights, then pills, then the output. A sketch snapping to clean vector marks the transformation (3#29).
- **A graph that grows from one named node,** an answer that says it used memory, then the memory as a readable page (5#23). This is the closest analog to supermemory in the set.
- **Long pieces** (over about 60s) need a chapter chip, a progress bar and caption pills (1#15).

## Study these first

| Ref | Post | Why |
|---|---|---|
| 1#8 | [@tibo_maker](https://x.com/tibo_maker/status/2105980242321924284) | One persistent object through every beat; strike the wrong model first |
| 1#9 | [@starks_arq](https://x.com/starks_arq/status/2097434906167251118) | Question complete by 1s; analogy morph; a contrast close with sources |
| 5#23 | [@perplexity_ai](https://x.com/perplexity_ai/status/2067642139014742348) | Memory as a growing graph, then an answer citing memory, then a memory page |
| 3#2 | [@kevin_t_ngo](https://x.com/kevin_t_ngo/status/2099858454043349342) | Two registers alternating; an ink-scribble wipe; 1.2M views in 27s |
| 3#29 | [@sudo_kiran](https://x.com/sudo_kiran/status/2104194783178785203) | Extraction as highlights lifting into pills |
| 1#25 | [@abdinmotion](https://x.com/abdinmotion/status/2101753294641078579) | The story skeleton labelled on a timeline as it plays; one dot with changing meaning |
| 2#16 | [@DhravyaShah](https://x.com/DhravyaShah/status/2100403461796003887) | supermemory's own: facts, "days later", an answer with lines to memory. Change its layout next time |

## Pitfalls

- Slow builds that leave the frame still (median 50% moving here).
- Unsourced numbers.
- An 8-minute generated lecture with one small icon for the first 3s (1#14): it only works when the post carries the hook.

## Build it here

- Use `engine/reference-16x9.swift`, the mcp-upload explainer engine.
- Story from `story.md`, morphs from `motion-grammar.md`, the frame from `brand.md` section 4.
- QA from `qa.md`.
