# Inspiration and references

Muskan's takeaway from the @himanshubuildss reel (2026-10-03, about 109k views, https://x.com/himanshubuildss/status/2106411655055974640): "people love when there's a lot of movement, things blending into each other from one thing to the other." That reaction is the reason for the continuous-morph direction in this skill.

**How to use any reference:** take the motion only. Never its palette, fonts, logos or layout. "Borrow mechanisms, never layouts, logos or footage" (motion-video-kit, via code-motion-graphics). The brand surface always wins. Never use component kits to rebuild supermemory's product UI: product UI comes from a real capture.

---

## 1. Design resources (a short pick from the @himanshubuildss list)

His post lists 40 resources. These are the ones most useful for motion and for the site-like look. Descriptions paraphrase his post. The links were not opened for this skill.

| Resource | What it is (per the post) | Why it helps here |
|---|---|---|
| scrolltide.co | his number one pick: complete prompts for award-style sites, with source code. **His X bio says he founded it, so treat this as self-promotion** | prompt structure ideas only |
| minimal.gallery | curated high-end sites | restraint, type, white space |
| godly.website | curated beautiful websites | layout and type references |
| landing.love | a showcase of animation-heavy websites | transition and morph ideas |
| hoverstat.es | experimental web design | unusual transitions |
| styles.refero.design | 2,000+ real product styles with typography | how product sites pair mono labels and sans statements |
| designmd.ai | design systems written as markdown an agent can read | a model for writing the brand as data |
| motion-primitives.com | advanced interaction patterns | state-morph ideas |
| kinetics.colorion.co | 150+ motion effects with React code and prompts | named effects to translate into `render(t)` |
| microkit.co | micro-interactions | small on-beat events |
| animejs.com | a lightweight animation engine | easing and timeline ideas |

### From @devjuninho (2026-10-05, about 53k views and 1.8k bookmarks; she sent it on 2026-10-06)

A Portuguese list of eight design-reference sites (https://x.com/devjuninho/status/2107144645524291730). Descriptions paraphrase his post; the sites were not opened for this skill. The post ends by selling his own course on building and selling websites (self-promotion).

| Resource | What it is (per the post) | Why it helps here |
|---|---|---|
| 60fps.design | fine details of micro-interactions and animations | the closest to motion: small on-beat events, state changes, easing |
| bentogrids.com | bento-grid layout ideas | targets for the "card unfolds like a map into a bento" morph |
| jiro.build | 1,200+ ready-made design prompts for AI | prompt structure for briefing a design or video agent |
| unsection.com | ready-made website sections | layouts for site-like frames and end cards |
| cta.gallery | call-to-action inspiration | the closing frame and the command chip |
| navbar.gallery | navbar references | HUD rows and top bars |
| footer.design | footer ideas | lockup and end-card arrangements |
| 404s.design | creative 404 pages | playful failure states, the "it broke" beat |

### From @noahelhadedy (2026-10-05, about 6.8k views and 208 bookmarks; she sent it on 2026-10-06)

Eleven sites "every designer building with AI should bookmark" (https://x.com/noahelhadedy/status/2107137723387584705). The descriptions below are ours: the post is a bare list. His bio says he builds designbookmark.com, so that entry is self-promotion. The post's 5.7s video was not watched. The sites were not opened for this skill.

| Resource | What it is | Why it helps here |
|---|---|---|
| ui.aceternity.com | animated React and Tailwind components | named motion effects (beams, spotlights, card stacks) to translate into `render(t)` |
| magicui.design | animated UI components | the same: borrow the motion, redraw it in the brand surface |
| motion-primitives.com | interaction and motion patterns (also in the @himanshubuildss list above) | state-morph ideas |
| uiverse.io | open-source UI elements in CSS and Tailwind | small loaders, toggles and buttons for on-beat micro-events |
| 21st.dev | a registry of React components | layout and component ideas only. Never rebuild supermemory's product UI from it; rebuild the real UI from its measured DOM (her rule) |
| component.gallery | design-system components collected across many systems | how real systems style tabs, pills and cards |
| styles.refero.design | real product styles with typography (also above) | pairing mono labels with sans statements |
| minimal.gallery | curated high-end sites (also above) | restraint and white space |
| cta.gallery | call-to-action inspiration (also in @devjuninho's list) | the closing frame |
| 3dicons.co | a 3D icon set | 3D props only when a brief asks; the supermemory brand bans 3D by default |
| designbookmark.com | his own design bookmarking site (self-promotion) | none beyond the others |

Overlaps across the three lists sent on 2026-10-06 (@devjuninho, @noahelhadedy, @MaybeFlorent): cta.gallery appears twice. motion-primitives.com, minimal.gallery and styles.refero.design were already in the @himanshubuildss pick. For motion, start with 60fps.design, motion-primitives.com, ui.aceternity.com and magicui.design.

### From @MaybeFlorent (2026-10-05, about 4.4k views; she sent it on 2026-10-06)

Florent Ademaj (Framer and Webflow template designer, founder of @madebyoversight) posted that one person built 192 website templates with Claude (https://x.com/MaybeFlorent/status/2107080020925845888). He links his own store, so this is self-promotion and the 192 figure is his claim.

| Resource | What it is (per the post) | Why it helps here |
|---|---|---|
| supply.madebyoversight.com | 192+ website templates, one free | a large set of site-style layouts to study for frames and end cards |
| supply.madebyoversight.com/sections | 32 interactive sections | animated section patterns to translate into `render(t)` moves |

The 19.6s video (1200x674) is a showreel of those sections playing inside a floating browser window on a grey backdrop. One frame was checked (2026-10-06): a ring of photo frames orbiting a large serif headline, "Twenty-eight frames, one orbit". It is the same move as the plugin ring in the one-command film (`engine/console-film/`). The rest of the reel was not watched, because the clip would have to be downloaded, so ask her first.

---

## 2. Motion references

| Reference | What to take | Where |
|---|---|---|
| @rossaxbt UI-morph template (2026-10-03, about 34k views) | one shape morphing through many states, cursor-driven changes, camera zoom per state, 120 BPM with an action on every beat, one frame per beat before the full render | https://x.com/rossaxbt/status/2106396375269134597 |
| @rossaxbt launch-film template (2026-10-04, about 79k views) | one continuous take, each scene grows out of the last, text rising from a mask line, a black shape that floods the frame then shrinks into the next scene, a map-like unfold into a bento, 4-subframe motion blur, the single-frame pop scan | https://x.com/rossaxbt/status/2106758817161597021 |
| @twoclipping (late September 2026) | the code-motion-graphics notes credit the same two prompts to @twoclipping (the UI-morph prompt, status 2103273003555402193, and "Develop", revid gallery #8, status 2103835273813496100). Likely the original author | code-motion-graphics `references/gallery-lessons.md`, `prompting.md` |
| revid "Claude motion graphics" gallery, 64 posts | what each category teaches, with sponsored and non-Claude posts labelled | `~/.claude/skills/code-motion-graphics/references/gallery-lessons.md` |
| The X motion benchmark, 25 files measured | motion %, longest still, cuts and loudness of the top posts. Her own picks on it: @deedydas "muda" (#6), @LexnLin "tessel" (#19); @darel023 "Timing" (#14) was the motion reference for smfs v4 | the pack's `reference/x-motion-benchmark.md` |
| Her own bar | she pointed at the smfs v4 cut as the bar for memory-graph v3 | `~/Downloads/smfs_explainer_v4_27s.mp4` |
| Her recent cuts | memory-graph v3 (16:9, flood into the field film, HUD and progress rule), mcp-upload (stream into a counter, square) | `/Users/muskan/personal-supermemory/reports/videos/` |
| whatships.com | a free, independent reference directory that says it sells no placement (recommended, without disclosure, in @rexan_wong's post) | via code-motion-graphics `prompting.md` |
| 30 YouTube channels | formats, thumbnails, proof design for long-form | the pack's `skills/supermemory-youtube-production` |

Do not reuse claims from the posts. "$0" and "0 external tools" in the 79k post still relied on a downloaded track, a stock clip, Playwright and ffmpeg (the same caveat code-motion-graphics records for the "Develop" post).

---

## 3. Studying a reference

1. If it must be downloaded, ask first (name, source, size). Keep it out of the deliverable and out of git.
2. Make one contact sheet that spans the whole file (`qa.md` section 2.6).
3. Measure it with the same metric as her cuts (`qa.md` section 2.3), so the comparison is fair.
4. Write down its pacing (seconds per idea), its transitions (what survives each seam), its type sizes against the frame, and its accent budget.
5. Translate what you keep into the morph catalogue's terms (`motion-grammar.md`). Drop everything that conflicts with the brand surface.
