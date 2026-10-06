# X bookmarks for video work

A curated library of Muskan's X bookmarks that help with videos, motion graphics and the design they rely on. Built on 2026-10-06.

## How this was made

- **Scanned:** all 604 bookmarks in `~/content-engine/data/bookmarks.tsv`, matched one-to-one with the 604 `x_bookmark` documents in the Supermemory space `muskan_x_bookmarks` (the space also holds 2 unrelated test documents, which were ignored).
- **Kept:** 174 bookmarks: 115 in the ten main themes and 59 under Adjacent. 32 of the Adjacent ones are other product-launch posts with a video, kept by a fixed rule (video of 15 seconds or more and 100K+ views).
- **Per theme:** Code-made video and motion graphics (tools and workflows) 14; Reels and launch films to study 49; Prompts and prompt templates 4; Transitions, morphs and camera 2; Typography and text animation 2; Design galleries and references 9; UI animation and micro-interactions 7; AI video and image tools 21; Sound and music 3; YouTube and thumbnails 4; Adjacent 59.
- **Dates:** post dates run from 2025-06-25 to 2026-10-04; 596 of the 604 posts fall between 2026-06-05 and 2026-10-04 (the TSV `date` column is the post date, not the save date).
- **Method:** read the full text of every bookmark from Supermemory (`GET /v3/documents/<id>`), then fetched the public post JSON from api.fxtwitter.com for 328 candidates (about 1 request per second) to get expanded links, media type and length, X Article text, quoted posts and community notes. Each kept post was classified by hand with one primary theme; related themes are listed under "See also". No media was downloaded and nothing in Supermemory was changed.
- **Text gaps fixed:** Supermemory's copy cuts long posts short (104 of the 117 long posts fetched; 50 of them are kept here) and 31 bookmarks were only a link (27 of them X Articles), so full text, article bodies and expanded links come from the public post data.
- **Numbers:** `views` come from the TSV export. The TSV's fourth column is the bookmark count, not likes (checked against live data), so the JSON stores it as `bookmarks_tsv` and takes `likes` from the public post data as of 2026-10-06.
- **Left out:** pure AI-model news, funding and growth posts with no visual element, agent and SEO tooling, podcasts and long tool tutorials, and launch posts below the rule above.
- **Text rules:** everything is paraphrased; quotes are short and only where the wording matters. Where a post doesn't say something, the table says it is unclear. 22 kept items are by or about supermemory or Muskan; they are flagged.
- **JSON:** `bookmarks_relevant.json` holds every kept item. `text` is the first 600 characters of the post; when a post is only an X Article link, it holds the article title and opening instead, prefixed `[X Article]`.
- **Each row:** `views` from the TSV; `link` is the post; resources are the URLs linked in the post, its X Article or the post it quotes.

## Top 15

1. **@RaphaelAubryy** (2026-09-28) https://x.com/RaphaelAubryy/status/2104502744010629269: Open-source Claude Code skill plus article covering every stage of a code-film pipeline like hers: beat map, stills, springs, motion blur, sound on peaks, self-critique.
2. **@rossaxbt** (2026-10-04) https://x.com/rossaxbt/status/2106758817161597021: Complete, reusable launch-film prompt: continuous take, morph chain, liquid glass, beat-locked SFX and a deterministic render recipe.
3. **@rossaxbt** (2026-10-03) https://x.com/rossaxbt/status/2106396375269134597: Morph-transition template (one UI shape through many states) that matches her morph direction, with spring and loop rules.
4. **@jake11moran** (2026-08-03) https://x.com/jake11moran/status/2084382572898070964: Storyboard-first workflow and named motion rules (continuous camera, in-flight transitions) from a strong launch film.
5. **@jake11moran** (2026-09-22) https://x.com/jake11moran/status/2102544324445848031: Ready HyperFrames skill for a 3D camera plus caption move to study and port.
6. **@LexnLin** (2026-09-27) https://x.com/LexnLin/status/2104148233106723099: Proof that soundtrack and SFX can be code on the same timeline as the picture.
7. **@notdwd** (2026-09-26) https://x.com/notdwd/status/2103959324385300552: Reference-remake method: rebuild a proven launch film's cuts and motion for a new brand, checked side by side.
8. **@chefbrent** (2026-08-15) https://x.com/chefbrent/status/2088708021257928713: Timestamped review loop between her notes and the agent's renders.
9. **@Miguel07Code** (2026-10-01) https://x.com/Miguel07Code/status/2105453292008661458: Depth-of-field and focus-pull hierarchy in a deterministic HyperFrames film, with the concept prompt.
10. **@tushaarmehtaa** (2026-06-20) https://x.com/tushaarmehtaa/status/2068209228565918154: Animation-review and anti-slop skills (Emil Kowalski) to add as a QA gate.
11. **@filippocarnvl** (2026-09-10) https://x.com/filippocarnvl/status/2098112186573082702: Why launch formats die and how to pick an unseen shape; 18s text-led film example.
12. **@romanbuildsaas** (2026-07-26) https://x.com/romanbuildsaas/status/2081351890306998400: Launch-video format costs and hook rules from 10+ real launches.
13. **@abdinmotion** (2026-09-20) https://x.com/abdinmotion/status/2101753294641078579: Viral launch-video anatomy as a pre-storyboard checklist.
14. **@dabit3** (2026-09-28) https://x.com/dabit3/status/2104579506853785637: Agent-recorded product tutorials with a shared prompt; screen-recording polish at scale.
15. **@himanshubuildss** (2026-10-03) https://x.com/himanshubuildss/status/2106411655055974640: 40 design and motion references: galleries, animated component kits, shader and 3D learning.

Also strong: @lennysan's Fable one-shot with ElevenLabs music (https://x.com/lennysan/status/2082502439597678688), QuiverAI's Arrow 2 editable vector generation (https://x.com/QuiverAI/status/2100295136261349802), @deedydas's 3Blue1Brown-style paper explainer (https://x.com/deedydas/status/2103141339651350646), the GPT Images 2.5 course by @Av1dlive (https://x.com/Av1dlive/status/2098055179761525165).

## Quick routes

- **Launch film in code:** Top 15 items 1-4 and 7, then Reels > Launch-video strategy, then Prompts.
- **Morphs, camera and kinetic type:** Transitions, Typography, and @rossaxbt's two templates.
- **Sound:** Sound and music, plus @RaphaelAubryy's article (drop by bass energy, SFX on measured peaks, -14 LUFS).
- **Explainers and changelogs:** Reels > Explainers and Reels > Changelog videos, next to her own changelog.
- **Review and QA loops:** @chefbrent (timestamped review), @tushaarmehtaa (animation review skills), @thesherlocker (brand verifier loop).
- **References and assets:** Design galleries, UI animation, and the Resource index.
- **Photoreal or generated footage:** AI video and image tools.

## Code-made video and motion graphics (tools and workflows)

How films get built in code: pipelines, skills, review loops, editable-video tools and editing agents. 14 bookmarks.

### Pipelines, skills and workflows

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-09-28 | @RaphaelAubryy | 393,262 | https://x.com/RaphaelAubryy/status/2104502744010629269 | X Article: 10+ Opus 5.5 motion videos in 3 days, plus the open-source Claude Code skill that packages the whole pipeline (no After Effects). | Beat map, 4 stills before render, closed-form springs, 8-subframe tmix blur, drop found by bass energy, SFX on peaks, -14 LUFS, 1-10 frame critique. | https://x.com/i/article/2104303014542512128<br>https://github.com/howseen-ai/claude-motion-design<br>https://howseen.ai<br>https://x.com/RaphaelAubryy/status/2104178266990858739<br>https://x.com/RaphaelAubryy/status/2103500173909356632<br>https://x.com/RaphaelAubryy/status/2104300246268571733 | self-promo (author's SaaS Howseen in PS) |
| 2026-08-03 | @jake11moran | 42,026 | https://x.com/jake11moran/status/2084382572898070964 | Quoted X Article: how he made Lenny's Product Pass launch film with Fable and website-to-hyperframes, in one prompt plus four revision prompts. | HTML storyboard of stills first; local motion skills: one continuous camera, no idle motion, scenes exit and enter in flight; 12fps stop-motion over smooth camera. | https://x.com/jake11moran/status/2084381821685657863<br>https://x.com/i/article/2084363820752109568 | none |
| 2026-09-26 | @notdwd | 121,413 | https://x.com/notdwd/status/2103959324385300552 | Side-by-side: Gojiberry's launch video and an Opus 5.5 rebuild for his brand made in 15 minutes, same motion and cuts, playing in sync. | Reference-remake method: keep a proven film's cut timing and motion grammar, swap in your brand, check by playing both in sync. | none | prompt and process are in replies (not captured); reference credited to @gojiberryai |
| 2026-08-15 | @chefbrent | 5,601 | https://x.com/chefbrent/status/2088708021257928713 | His Codex video workflow: a single-player Frame.io-style review app he built (Cutroom); Codex uploads each revision, he leaves timestamped comments. | Build a review loop: every render lands in one player, notes are timestamped, the agent revises against them. | none | low reach (5.6K views) |
| 2026-09-28 | @dabit3 | 109,884 | https://x.com/dabit3/status/2104579506853785637 | Cloud agent (Devin) records pixel-perfect product tutorials by using the app like a human; linked article plus the prompt as a gist. | Give the agent a signed-in machine, docs and a style guide; it records, annotates clicks, blurs secrets; trigger renders per changelog. | https://x.com/i/article/2103573841176141824<br>https://gist.github.com/dabit3/5d3969b61db56dc150c161b46350584a<br>https://devin.ai/ | Devin promotion |
| 2026-09-15 | @kevin_t_ngo | 1,163,195 | https://x.com/kevin_t_ngo/status/2099858454043349342 | Claude Opus 5 drew every frame of a 27-second square animation in JavaScript: the life of a fruit fly. | Frame-by-frame drawing in code suits illustrated science stories; square 1080 format; no footage needed. | none | none |

### Editable-video tools

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-09-28 | @sab8a | 335,691 | https://x.com/sab8a/status/2104627757766578399 | Open Edit: open-source agent that turns Opus 5.5-made videos into editable browser projects (60s demo). | Keep code-made films editable after the first render; read the installer before using it. | none | community note: init adds session-start hooks that run npx @veedstudio/openedit-cli every session; review before installing; GitHub link in replies |
| 2026-08-05 | @willyhopps | 364,119 | https://x.com/willyhopps/status/2085033689973711030 | Osmo public launch: an editable video platform that turns Figma, code and reference videos into editable motion; founder left A24; $5M seed. | A route for keeping motion editable from Figma or code sources; the 90s 4:3 launch film is itself a reference. | none | launch and funding announcement |

### Editing and post-production agents

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-09-24 | @gregpr07 | 57,398 | https://x.com/gregpr07/status/2102984873351037161 | Opus 5.5 with video-use chose the clean take of 13, then cut, graded and captioned it in 2 minutes for 90 cents. | Transcript-first take selection, then frame comparison of the top three; let the agent critique and rewrite its own captions. | none | none |
| 2026-09-25 | @mattyp | 37,555 | https://x.com/mattyp/status/2103507834009014459 | He is building a video editor by letting a Cursor cloud agent edit his video over MCP, test the UI and fix failures. | Agent loop for editing tools: edit, test the UI, reflect on each failure, fix, repeat until one clean end-to-end edit. | none | none |
| 2026-09-11 | @nidhisinghattri | 2,158 | https://x.com/nidhisinghattri/status/2098453574573539807 | A 10-minute test of DeepSeek V4.1 Flash inside Claude Code editing raw clips; the run cost $0.33; chapters in the post. | Benchmark for cheap agent edits of raw footage; chaptered walkthrough format. | none | low reach (2.2K views) |
| 2026-09-15 | @camiinthisthang | 23,586 | https://x.com/camiinthisthang/status/2099888043746562185 | Creator with about 5M views a month combines GPT-6 Astra and Gemini's agentic video understanding to turn raw footage into on-brand edits. | Pair a video-understanding model with an editing agent so cuts follow a written brand aesthetic. | none | engagement bait (comment 'video' for the prompt) |
| 2026-08-30 | @VadimStrizheus | 9,398 | https://x.com/VadimStrizheus/status/2094194476252016861 | Grok Bot with the vugola MCP server now cuts dead space, clips videos, adds captions and posts to social. | Automate the boring passes (silence cuts, captions, clips) so effort goes into the hero edit. | none | hype; quotes his own Aug 28 post |
| 2026-08-28 | @VadimStrizheus | 55,220 | https://x.com/VadimStrizheus/status/2093141495658201368 | Grok Bot plus vugola MCP downloads YouTube videos, reframes ratios, adds hooks and captions, schedules posts and reads clip analytics. | Reframe-per-platform and hook-caption passes can be agent jobs; keep a human on the master edit. | none | hype |

See also, listed in other sections: @Miguel07Code (2026-09-22, under Reels) https://x.com/Miguel07Code/status/2102441708395041170; @deedydas (2026-09-24, under Reels) https://x.com/deedydas/status/2103141339651350646; @Miguel07Code (2026-10-01, under Transitions) https://x.com/Miguel07Code/status/2105453292008661458; @shiri_shh (2026-06-11, under Typography) https://x.com/shiri_shh/status/2064983887017836631; @higgsfield_ai (2026-09-26, under AI tools) https://x.com/higgsfield_ai/status/2103875279588602225; @LexnLin (2026-09-27, under Sound) https://x.com/LexnLin/status/2104148233106723099.

## Reels and launch films to study

Films worth watching before storyboarding, plus the strategy posts that explain why launches work. 49 bookmarks.

### Launch-video strategy and breakdowns

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-09-10 | @filippocarnvl | 125,274 | https://x.com/filippocarnvl/status/2098112186573082702 | X Article from Epta Studios: launch formats die once copied; cites Lemma, Pocket and intelligence.co launches and their own 18s text-led film. | Ask whether buyers saw this shape in the last 90 days; borrow from outside tech; flip the category's loudest trait. | https://x.com/i/article/2098106886893830144<br>https://intelligence.co/<br>https://x.com/ndrewpignanelli/status/2051323944452411773<br>https://x.com/AkshayNarisetti/status/2077439335130124544<br>https://lnkd.in/p/ew9iCKd5<br>https://cal.com/eptastudios/introduction-call-with-epta | agency self-promo (booking link) |
| 2026-07-26 | @romanbuildsaas | 15,467 | https://x.com/romanbuildsaas/status/2081351890306998400 | Gojiberry's launch-video playbook: 10+ launches, 1.5M views; motion design (~$5k) beat studio (~$500-600) and face cam ($0). | Hook in the first 10 seconds, cut every spare word, make the problem clear within 30s, link in first comment. | none | credits @1600Agency, @PodspaceFR, @james_alleyy, @wickedguro |
| 2026-09-20 | @abdinmotion | 99,949 | https://x.com/abdinmotion/status/2101753294641078579 | 28-second video titled 'the anatomy of a viral launch video'. | Checklist reference before storyboarding; the breakdown lives in the video, not the text. | none | content not described in the text |
| 2026-09-11 | @titouangillet_ | 88,509 | https://x.com/titouangillet_/status/2098423993652887785 | Breakdown of the 'new Cloudflare' rebrand launch video by @tjcages, which drew 695K+ views. | Study how a rebrand launch is structured; the 55s attachment appears to be the breakdown. | https://x.com/tjcages/status/1976657115633868884 | author makes launch videos (@vizionarymov); breakdown format unclear from the post; credits @tjcages |
| 2026-10-01 | @askOkara | 6,009 | https://x.com/askOkara/status/2105645291533951141 | Okara's launch library: hundreds of X launch examples in one place. | Scan it before scripting to see which launch shapes are saturated right now. | https://okara.ai/launch-library | self-promo (Okara) |
| 2026-09-27 | @rajsinghfirst | 4,075 | https://x.com/rajsinghfirst/status/2104174846372708586 | A 26-second launch video that got 10K+ views, with a 'full breakdown' promised. | Small-account launch benchmark; breakdown not in the post. | none | breakdown not captured (likely replies) |

### Code- and AI-made films

Video lengths here run 14s to 103s (median 33s).

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-07-29 | @lennysan | 348,055 | https://x.com/lennysan/status/2082502439597678688 | Fable read Lenny's launch post and one-shotted a 33s launch video in 46 minutes, then made music in ElevenLabs via his browser and mixed it. | Point the agent at the launch post as the brief; let it fetch logos; add music as a separate pass. | https://www.lennysproductpass.com/<br>https://www.lennysnewsletter.com/p/productpass-summer2026launch | none |
| 2026-09-28 | @gauravsbuilding | 423,419 | https://x.com/gauravsbuilding/status/2104370091672711402 | Opus 5.5 in 'Ultracode' mode ran 12 hours on a 'best motion design launch video' brief and produced a 15s film. | Twelve hours of autonomous running yielded 15 seconds; review gates matter more than run length. | none | none |
| 2026-09-27 | @damonchen | 19,883 | https://x.com/damonchen/status/2104207711844049157 | One-shot 30s product demo video from Opus 5.5, framed against the $3k and 7 days an agency demo used to cost. | Cost-and-time contrast makes a strong post hook for a code-made demo. | none | none |
| 2026-09-23 | @chhddavid | 142,110 | https://x.com/chhddavid/status/2102666619029999989 | 50-second 4K motion video Opus 5.5 generated in 19 minutes with only two changes. | Benchmark for one-shot quality at 4K; compare pacing against her own films. | none | none |
| 2026-09-23 | @nazmijavierl | 121,701 | https://x.com/nazmijavierl/status/2102712897701097828 | Graphic posts plus animation made from one Opus 5.5 prompt by a creative director (16s, 4:3). | One prompt can yield a matched set: static posts and the animated version together. | none | none |
| 2026-09-23 | @titouangillet_ | 13,041 | https://x.com/titouangillet_/status/2102685529544298668 | 53-second Opus 5.5 video made with 3 or 4 prompts over 2 hours by a launch-video maker. | Realistic effort benchmark: a few prompts and about two hours for a 53s film. | none | author sells launch videos (@vizionarymov) |
| 2026-09-22 | @Miguel07Code | 153,362 | https://x.com/Miguel07Code/status/2102441708395041170 | Opus 5.5 one-shot the 58s launch video for shotbaseapp with HyperFrames in under 20 minutes. | HyperFrames one-shot reference at 58s; useful to compare against her Swift renders. | none | none |
| 2026-10-03 | @runable_hq | 222,953 | https://x.com/runable_hq/status/2106407527776944555 | Runable says this 48-second ad was made for $21.56. | Cost benchmark for a full 16:9 ad; method is not in the post. | none | brand self-promo (Runable); method unclear |
| 2026-10-02 | @LexnLin | 78,552 | https://x.com/LexnLin/status/2106101651010449796 | Claude Opus 5.5 made its own 14.5s vertical ad, meant to be watched with sound on. | 9:16 under-15s ad with sound as a core element; prompt and strategy are in replies. | none | prompt in replies (not captured) |
| 2026-09-13 | @Ishansharma7390 | 42,087 | https://x.com/Ishansharma7390/status/2099170895717949910 | A 24s iPhone ad for India that he says GPT-6 Astra made. | Market-localised ad concept; tools and method unclear from the post. | none | method unclear |
| 2026-08-03 | @byhewar | 58,151 | https://x.com/byhewar/status/2084261110908145666 | 65-second high-resolution video presented as made entirely by AI. | Quality reference only; tools and process are not named. | none | tools unclear from the post |
| 2026-07-30 | @jxnlco | 2,292,045 | https://x.com/jxnlco/status/2082855170296205719 | OpenAI employee's 103s mission and recruiting video made with Codex; his team chose to produce and share it; 2.3M views. | First-person culture film made with Codex; a format for team, mission or hiring videos. | none | none |
| 2026-09-26 | @aizal_mp4 | 27,354 | https://x.com/aizal_mp4/status/2103862408074985492 | 'POV: we make a cool motion video for your company', a 21s showreel-style clip from a motion designer and founder. | POV framing as a hook for a service showreel. | none | self-promo (motion agency) |
| 2026-09-22 | @leomeethewoo | 205,826 | https://x.com/leomeethewoo/status/2102412626278113486 | 'AI will never beat my team': a 15s 4K clip from a studio making product videos for fintech. | Human-studio counter-positioning; what the clip shows is unclear from the post. | none | self-promo (agency); content unclear |
| 2026-09-09 | @DholakiaJaydeep | 12,768 | https://x.com/DholakiaJaydeep/status/2097736024214688145 | Launch video shipped in under 20 hours with MiniMax, online clips, Claude and a punchy edit; no shoot, storyboard or script. | Emergency recipe: stock clips plus generated shots plus fast cutting when there's no time for motion graphics. | none | self-promo (offering slots) |

### Explainers

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-10-02 | @tibo_maker | 599,058 | https://x.com/tibo_maker/status/2105980242321924284 | A 66s custom explainer of how Shazam works, posted with Karpathy's note that bespoke explainer videos are the output he's most bullish on. | Karpathy's pattern: ask for a '3b1b style video explainer on X' with ElevenLabs narration. | none | quotes @karpathy; tools used for this video unclear |
| 2026-09-27 | @deedydas | 252,924 | https://x.com/deedydas/status/2104151743907160546 | Paul Graham's essay 'How to Do Great Work' turned into a video under 200 seconds with Opus. | Essay-to-video adaptation length benchmark: about 3 minutes for a long essay. | none | none |
| 2026-09-24 | @deedydas | 331,088 | https://x.com/deedydas/status/2103141339651350646 | An 8-minute 3Blue1Brown-style video generated from a research paper with Opus 5.5. | Paper-to-explainer is feasible at long length; 3b1b style is a reachable default look. | none | none |
| 2026-09-08 | @starks_arq | 491,883 | https://x.com/starks_arq/status/2097434906167251118 | 63s square explainer: GPT-6 Astra explains OpenAI's Navier-Stokes announcement to an average person. | Ride a big announcement with a plain-language explainer; square format. | none | none |

### Creative launch films

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-09-23 | @maximusgrave | 4,677,011 | https://x.com/maximusgrave/status/2102800008982777902 | 'Say hi to Sidehoe' app launch; a community note says it is a parody ad for an app-launch video service. | Parody launch as a showcase for launch-video skills; 31s square; 4.7M views. | https://sidehoe.chat | parody per community note |
| 2026-07-18 | @AkshayNarisetti | 64,601 | https://x.com/AkshayNarisetti/status/2078523383701176402 | Behind-the-scenes set photos from Pocket's launch film shoot ('meet your heroes'), quoting the 90s Pocket launch. | Out-of-category celebrity casting; the Epta article (@filippocarnvl) says Pocket cast the actor who plays Louis Litt. | https://x.com/AkshayNarisetti/status/2077439335130124544 | none |
| 2026-06-25 | @adxtyahq | 92,261 | https://x.com/adxtyahq/status/2070138054233518426 | Calls Zaro's launch one of the cleanest AI product launches this year, and lists why. | Praised for selling a workflow, not a model; watch it next to the @ZaroAI_ film itself. | http://Zaro.ai | none |
| 2026-06-25 | @ZaroAI_ | 7,475,375 | https://x.com/ZaroAI_/status/2070084796378747316 | Zaro launch: 68.5s 4K film for a workspace that connects tools, files, apps and agents; 7.5M views. | Problem-first copy (scattered context) before the product reveal. | http://Zaro.ai | product launch |
| 2026-07-28 | @adambcohen93 | 402,891 | https://x.com/adambcohen93/status/2082122814539334018 | Weave's $13.5M Series A announced with a 144s film about a man trying to conquer his fears. | Funding films can be comedic short stories instead of founder talking heads. | none | funding announcement |
| 2026-09-10 | @eglyman | 651,765 | https://x.com/eglyman/status/2098049270553383031 | Ramp staged a one-night Broadway 'industrial musical' about bills; 17s 4K teaser. | Revive an old corporate format as the creative hook. | http://billpaythemusical.com | brand stunt |
| 2026-06-17 | @d4nielpark | 17,484 | https://x.com/d4nielpark/status/2067261766862528961 | Stan gives each new hire their own launch video; this 53s one introduces hire #1. | Hire-announcement films as a repeatable format. | none | none |

### Changelog videos

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-09-23 | @mattyp | 41,553,227 | https://x.com/mattyp/status/2102759899314741736 | Weekly 'what's new in Grok Bot' video (2:24) with chapter timestamps in the post copy; 41.6M views. | Changelog format: one feature per chapter, timestamps in the copy; compare with her own Oct 2 changelog. | none | none |
| 2026-09-08 | @mattyp | 62,195 | https://x.com/mattyp/status/2097411358891630786 | Another 'what's new in Grok Bot' update video (75s) listing five features. | Numbered feature list in copy mirrors the video's order. | none | none |

### supermemory and Muskan's own films

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-10-02 | @Muskanjain0401 | 9,061 | https://x.com/Muskanjain0401/status/2105969838317547925 | Her own 140s changelog video of everything supermemory shipped last week, with chapter timestamps. | Her baseline for the changelog format; compare with @mattyp's weekly Grok Bot updates. | none | own post |
| 2026-08-17 | @Muskanjain0401 | 2,600,985 | https://x.com/Muskanjain0401/status/2089261488104222835 | Her 9-second 4K launch clip for tryemployable.ai (auto-applies to jobs); the post reached 2.6M views. | A very short clip can front a big launch post; what drove the reach is unclear. | https://tryemployable.ai | own post |
| 2026-09-07 | @supermemory | 1,866,803 | https://x.com/supermemory/status/2097035274094272935 | supermemory's learner-1 launch film (80s); 1.87M views. | Company launch reference for tone, length and reach. | none | own company |
| 2026-07-31 | @DhravyaShah | 28,489 | https://x.com/DhravyaShah/status/2083257638406803639 | Launch video (41s) for the new supermemory MCP: teams, shared context, interactive components 'watch till the end'. | End-of-video payoff tease in the copy. | https://supermemory.ai/docs/supermemory-mcp/mcp | own company |
| 2026-07-31 | @_prasanna_ap | 27,390 | https://x.com/_prasanna_ap/status/2083261343805948384 | Prasanna on the MCP launch video: GPT-5.6 Sol, '$1346', about 3 focused hours. | Time benchmark for an in-house AI-made launch film; what the $1,346 covers is unclear. | none | own company; cost figure unexplained |
| 2026-07-31 | @DhravyaShah | 20,214 | https://x.com/DhravyaShah/status/2083262261263761506 | Dhravya: the MCP launch video was made with AI in 3 hours by an engineer with taste. | Taste plus AI tools is the internal framing for these films. | none | own company |
| 2026-09-17 | @DhravyaShah | 17,424 | https://x.com/DhravyaShah/status/2100403461796003887 | 36s video of supermemory working inside the Vercel eve harness: memories formed, indexed and injected back. | Product-in-context demo of memory forming; 1280x800 screen format. | none | own company |
| 2026-09-17 | @DhravyaShah | 4,186 | https://x.com/DhravyaShah/status/2100405061994324168 | Dhravya says his Sep 17 eve harness video was made in two shots with Fable. | Two-shot agent workflow is enough for simple product explainers. | none | own company |
| 2026-09-17 | @supermemory | 9,677 | https://x.com/supermemory/status/2100625423726182819 | 37s launch video for the supermemory plugin for Meta's Muse Code. | Partner-plugin launch format. | none | own company |
| 2026-09-08 | @theCTO | 15,166 | https://x.com/theCTO/status/2097127783881171422 | 16s 4K launch clip for supermemory x Keiki: deploy an agent that remembers everything in under a minute. | Short partner-launch clip at 4K. | https://onkeiki.com<br>https://supermemory.ai | own company (partner launch) |
| 2026-05-27 | @DhravyaShah | 97,368 | https://x.com/DhravyaShah/status/2059477105529049162 | 'The Context Cloud for agents': 5.5-minute launch video for the new supermemory (memory, RAG, filesystems, profiles as blocks). | Long-form launch reference; contrast with the short cuts. | none | own company |
| 2025-11-04 | @DhravyaShah | 21,750 | https://x.com/DhravyaShah/status/1985796841150300473 | 'What is supermemory?' 80s explainer video (Nov 2025). | Earlier brand explainer; check messaging against current positioning. | none | own company; older post |
| 2025-12-10 | @DhravyaShah | 121,219 | https://x.com/DhravyaShah/status/1998586996437168512 | 190s video on how supermemory thinks about measuring memory (evals and vibes), Dec 2025. | Research-explainer reference; verify any benchmark claims before reuse. | none | own company; older post |
| 2026-02-10 | @DhravyaShah | 36,752 | https://x.com/DhravyaShah/status/2021288232688943393 | 49s 4K video relaunching supermemory's consumer app (Feb 2026). | Consumer-facing tone reference; check current product status before reusing its messaging. | none | own company; older post |
| 2026-06-12 | @DhravyaShah | 7,204 | https://x.com/DhravyaShah/status/2065269543313010707 | 12s clip announcing new SMFS research. | Short research-update clip format. | http://SMFS.ai | own company; content unclear |

See also, listed in other sections: @notdwd (2026-09-26, under Code-made video) https://x.com/notdwd/status/2103959324385300552; @dabit3 (2026-09-28, under Code-made video) https://x.com/dabit3/status/2104579506853785637; @kevin_t_ngo (2026-09-15, under Code-made video) https://x.com/kevin_t_ngo/status/2099858454043349342; @gregpr07 (2026-09-24, under Code-made video) https://x.com/gregpr07/status/2102984873351037161; @deedydas (2026-09-23, under Prompts) https://x.com/deedydas/status/2102787937482252537; @LexnLin (2026-09-27, under Sound) https://x.com/LexnLin/status/2104148233106723099; @austinh___ (2026-09-29, under Sound) https://x.com/austinh___/status/2104941773420122177.

## Prompts and prompt templates

Prompts given in full or near-full in the post. 4 bookmarks.

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-10-04 | @rossaxbt | 39,754 | https://x.com/rossaxbt/status/2106758817161597021 | Full open prompt for a $0, code-only 29s square launch film: inputs, direction, 54-beat structure, build rules, gotchas. | One continuous take where objects transform; iris, goo and liquid-glass recipes; seek(t) springs; SFX on peaks; check one frame per beat. | https://x.com/i/article/2105626165704572928<br>https://www.remotion.dev/docs/the-fundamentals<br>https://github.com/heygen-com/hyperframes/blob/main/docs/developers/overview.mdx | quotes @0xwhrrari's 'Motion Engineering' X Article; Mixkit and Pexels named, not linked |
| 2026-09-27 | @sudo_kiran | 10,433 | https://x.com/sudo_kiran/status/2104194783178785203 | Short prompt that got Opus 5.5 to make a product motion demo: research the product, make a 40s showreel-style video, go all out. | Framing trick: ask the model to prove it's a great motion designer, 'like it's your showreel'. | none | none |
| 2026-09-23 | @deedydas | 346,896 | https://x.com/deedydas/status/2102787937482252537 | 26s launch video for an inference startup from a one-line prompt, about $2 and one minute per the post. | Prompt used: a 'modern slick and punchy video' for the startup; he notes photoreal generators like Seedance help less for technical explainers. | none | none |
| 2026-09-10 | @Av1dlive | 260,128 | https://x.com/Av1dlive/status/2098055179761525165 | X Article course on GPT Images 2.5: 14 tricks, 44 examples, a brief structure and a repair workflow. | Brief order: purpose, canvas, contents, relationships, appearance, checks; bind attributes to objects; one edit at a time. | https://x.com/i/article/2098012383679819776<br>https://developers.openai.com/api/docs/guides/image-prompting?model=gpt-image-2.5 | none |

See also, listed in other sections: @RaphaelAubryy (2026-09-28, under Code-made video) https://x.com/RaphaelAubryy/status/2104502744010629269; @jake11moran (2026-08-03, under Code-made video) https://x.com/jake11moran/status/2084382572898070964; @notdwd (2026-09-26, under Code-made video) https://x.com/notdwd/status/2103959324385300552; @tibo_maker (2026-10-02, under Reels) https://x.com/tibo_maker/status/2105980242321924284; @rossaxbt (2026-10-03, under Transitions) https://x.com/rossaxbt/status/2106396375269134597; @Miguel07Code (2026-10-01, under Transitions) https://x.com/Miguel07Code/status/2105453292008661458; @PJaccetturo (2026-09-16, under AI tools) https://x.com/PJaccetturo/status/2100218143625073088; @abxxai (2026-09-09, under AI tools) https://x.com/abxxai/status/2097698694296686623; @shardul_mane (2026-08-02, under AI tools) https://x.com/shardul_mane/status/2083737041146372153.

## Transitions, morphs and camera

Morph chains, focus pulls and camera moves. 2 bookmarks.

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-10-03 | @rossaxbt | 33,388 | https://x.com/rossaxbt/status/2106396375269134597 | Open prompt template for a 14s code-only UI morph: one shape becomes button, loader, player, slider, toggle, tabs, chart, command palette, toast. | Same element changes size, radius and color; separate springs for leading and trailing edges; action on every beat; last frame equals first. | https://x.com/i/article/2105626165704572928<br>https://www.remotion.dev/docs/the-fundamentals<br>https://github.com/heygen-com/hyperframes/blob/main/docs/developers/overview.mdx | quotes @0xwhrrari's 'Motion Engineering' X Article; Mixkit named, not linked |
| 2026-10-01 | @Miguel07Code | 29,434 | https://x.com/Miguel07Code/status/2105453292008661458 | 39s HyperFrames film by Sonnet 5.5 (17 hours): a black glass instrument with three windows; camera pulls focus from depth to depth. | Carry hierarchy with optical depth: three.js glass, HTML-in-Canvas text, thin-lens depth of field, deterministic frames. | none | credits Ferrari Luce's layered display as the starting point |

See also, listed in other sections: @jake11moran (2026-08-03, under Code-made video) https://x.com/jake11moran/status/2084382572898070964; @rossaxbt (2026-10-04, under Prompts) https://x.com/rossaxbt/status/2106758817161597021; @jake11moran (2026-09-22, under Typography) https://x.com/jake11moran/status/2102544324445848031.

## Typography and text animation

Kinetic type and text effects. 2 bookmarks.

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-09-22 | @jake11moran | 109,420 | https://x.com/jake11moran/status/2102544324445848031 | Published HyperFrames community skill 'camera-3d-captions' for a 3D camera move with text effect, made with Opus 5.5. | Drop-in 3D camera plus caption motion; study its parameters to port the effect into her renderer. | https://github.com/heygen-com/hyperframes-community-skills/tree/master/skills/camera-3d-captions<br>https://x.com/jake11moran/status/2102493361743839432 | quotes his own 19s demo |
| 2026-06-11 | @shiri_shh | 5,503 | https://x.com/shiri_shh/status/2064983887017836631 | A black hole that sits in your terminal, grows the longer you code and bends text like gravity; shrinks when you take a break. | Gravitational text-warp as a kinetic-type idea for terminal scenes. | none | original developer not named in the post |

See also, listed in other sections: @jake11moran (2026-08-03, under Code-made video) https://x.com/jake11moran/status/2084382572898070964; @filippocarnvl (2026-09-10, under Reels) https://x.com/filippocarnvl/status/2098112186573082702; @rossaxbt (2026-10-04, under Prompts) https://x.com/rossaxbt/status/2106758817161597021.

## Design galleries and references

Where to pull visual references and design systems from. 9 bookmarks.

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-10-03 | @himanshubuildss | 103,395 | https://x.com/himanshubuildss/status/2106411655055974640 | 40 kept design resources for AI-built UI: prompt libraries, site galleries, animated component kits, shader and 3D learning, icons. | Pull references from landing.love, godly, refero styles; motion from motion-primitives, magicui, kinetics; shaders from shadertoy. | 40 links, all in the resource index (first: http://scrolltide.co) | first pick (scrolltide.co) heavily promoted; possible sponsorship (unclear) |
| 2026-10-03 | @amanbehumble | 88,568 | https://x.com/amanbehumble/status/2106271531391385693 | Recommends designeer.xyz (per the screenshot) as a curated set of interface craft, component libraries and AI tools to feed an AI. | Feed the agent curated references before it designs film UI. | https://designeer.xyz | site name taken from the screenshot |
| 2026-09-13 | @noahelhadedy | 113,127 | https://x.com/noahelhadedy/status/2099015197302071364 | List of DESIGN.md websites (design systems written as markdown for agents). | Hand the agent a DESIGN.md before building film UI so colors and type stay on-system. | https://typeui.sh<br>https://designmd.me<br>https://designmd.supply<br>https://styles.refero.design<br>https://getdesign.md<br>https://collectui.com<br>https://designmd-store.com | none |
| 2026-09-12 | @noahelhadedy | 87,045 | https://x.com/noahelhadedy/status/2098683254853321073 | List of mobile app inspiration websites. | Source real app screens and flows for phone-format scenes. | https://appshots.design<br>https://screensdesign.com<br>https://refero.design<br>https://pageflows.com<br>https://gummble.com<br>https://collectui.com<br>https://revyl.com | none |
| 2026-07-12 | @dhruvtwt_ | 66,024 | https://x.com/dhruvtwt_/status/2076362537365578207 | Curated grid of his favourite design engineers on X, part 2 (quotes part 1). | People to follow for motion and UI craft references. | https://x.com/dhruvtwt_/status/2075091446198382650 | none |
| 2026-09-30 | @PranavOriginals | 235,110 | https://x.com/PranavOriginals/status/2105346116388868364 | Website footer on a grainy dark-blue background with a detailed line-drawn landscape (per the image description). | Grain plus line illustration as an outro or end-card backdrop idea. | none | none |
| 2026-10-01 | @Muskanjain0401 | 2,751 | https://x.com/Muskanjain0401/status/2105667660436656566 | Her 16s video of the new supermemory.ai site. | Current site look and motion as the brand reference for films. | https://supermemory.ai | own post |
| 2026-08-05 | @ky__zo | 393,376 | https://x.com/ky__zo/status/2085067731230154921 | A website built with AI images and video (gpt-image-2, Seedance 2.0) that changes on every refresh, by @peardotno. | Generated media as living backgrounds; an idea for varied b-roll per render. | none | credits @peardotno |
| 2026-07-06 | @adilmania | 20,615 | https://x.com/adilmania/status/2073975073304981818 | Minimal personal site: a short bio page ('me in 11 lines'). | Restraint reference for text-only cards. | http://adilmania.com | low reach |

See also, listed in other sections: @askOkara (2026-10-01, under Reels) https://x.com/askOkara/status/2105645291533951141; @nazmijavierl (2026-09-23, under Reels) https://x.com/nazmijavierl/status/2102712897701097828; @tushaarmehtaa (2026-06-20, under UI animation) https://x.com/tushaarmehtaa/status/2068209228565918154; @heysaik (2026-09-30, under UI animation) https://x.com/heysaik/status/2105377008142463103; @gracewangdesign (2026-09-11, under UI animation) https://x.com/gracewangdesign/status/2098506237901963620; @benjitaylor (2026-09-23, under AI tools) https://x.com/benjitaylor/status/2102820884931354776; @QuiverAI (2026-09-16, under AI tools) https://x.com/QuiverAI/status/2100295136261349802; @aashatwt (2026-06-06, under AI tools) https://x.com/aashatwt/status/2063314625542996150.

## UI animation and micro-interactions

UI motion references and animation-review skills. 7 bookmarks.

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-06-20 | @tushaarmehtaa | 81,321 | https://x.com/tushaarmehtaa/status/2068209228565918154 | /remove-ai-slop skill for design and copy tells, inspired by Emil Kowalski's /review-animations and /emil-design-eng animation skills. | Add an animation-review pass (Emil's skill) and a slop-removal pass before final render. | http://tushaarmehtaa.xyz/skill<br>http://emilkowal.ski/skill | credits @emilkowalski and Cursor's code-quality skill |
| 2026-07-12 | @marina_uiux | 2,245,023 | https://x.com/marina_uiux/status/2076410277109645741 | 20s video of work-in-progress design experiments from a UI/UX designer; 2.2M views. | Reference for polished micro-motion; specifics are only in the video. | none | content not described in the text |
| 2026-09-29 | @lukaslevert | 38,818 | https://x.com/lukaslevert/status/2105063567062094000 | Parallel's contact form shown in a 13s clip ('name a better contact form'). | Form micro-interaction reference for UI moments inside product films. | https://contact.parallel.ai | none |
| 2026-09-30 | @heysaik | 81,693 | https://x.com/heysaik/status/2105377008142463103 | Personal website redesigned so it looks like agents are constructing it as you view it (105s demo). | 'Being built live' reveal is a natural motif for agent-product films. | none | none |
| 2026-09-11 | @gracewangdesign | 82,898 | https://x.com/gracewangdesign/status/2098506237901963620 | Portfolio site where you can go fishing (13s demo). | One playful interaction as a signature moment; the same idea works as a film beat. | https://gracewang.design | none |
| 2026-06-27 | @MaheshtheDev | 3,019 | https://x.com/MaheshtheDev/status/2070949197013217393 | 12s clip of a summarize interaction in supermemory's personal app, credited to the team's designer. | In-house UI motion to reuse in supermemory films. | none | own company |
| 2026-09-19 | @MaxRovensky | 229,586 | https://x.com/MaxRovensky/status/2101319093592682959 | 9.5s vertical demo of shyglass.app, a small privacy app he made. | Short phone-format app reveal; what the motion shows is unclear from the post. | https://shyglass.app | content unclear |

See also, listed in other sections: @rossaxbt (2026-10-03, under Transitions) https://x.com/rossaxbt/status/2106396375269134597; @himanshubuildss (2026-10-03, under Galleries) https://x.com/himanshubuildss/status/2106411655055974640; @dhruvtwt_ (2026-07-12, under Galleries) https://x.com/dhruvtwt_/status/2076362537365578207.

## AI video and image tools

Generative video and image models, pipelines and vendor launches. 21 bookmarks.

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-09-16 | @PJaccetturo | 9,612,246 | https://x.com/PJaccetturo/status/2100218143625073088 | A 6.5-minute AI film that cost $29,575 and took 10 days; thread shares a Claude skill and the Dreamina prompts. | AI film is not cheap at high quality; budget for days of iteration; thread holds the skill and prompts. | none | thread not captured |
| 2026-09-09 | @abxxai | 376,568 | https://x.com/abxxai/status/2097698694296686623 | 22s 4K realistic video made with GPT Image 2.5 and Seedance 2.5; the thread promises every prompt. | Pair an image model for stills with Seedance for motion when realism is needed. | none | thread not captured |
| 2026-08-01 | @venturetwins | 170,712 | https://x.com/venturetwins/status/2083641481911492619 | Seedance 2.5 cloned the poster's voice and look into an a16z SF office walkthrough from a photo, a talking clip and office pictures. | Reference-pack prompting: face photo plus voice clip plus location stills gives a presenter walkthrough. | none | none |
| 2026-09-22 | @BytePlusGlobal | 228,971 | https://x.com/BytePlusGlobal/status/2102358910443401590 | Draft Mode for Dreamina Seedance 2.5: explore in 480p, then render the chosen shot in native 1080p. | Draft cheap, then finalize while composition, motion and direction stay consistent. | none | brand promo (BytePlus) |
| 2026-09-21 | @BytePlusGlobal | 617,700 | https://x.com/BytePlusGlobal/status/2101893220288663884 | Dramagic: enterprise AI platform for short dramas: script analysis, asset setup, storyboard, video preview, consistency checks. | Copy the order: script analysis, asset sheet, storyboard, then preview. | none | brand promo (BytePlus) |
| 2026-06-07 | @minchoi | 108,728 | https://x.com/minchoi/status/2063748239262916674 | 15s vertical Seedance 2.0 clip pitched as 100% AI; thread of 10 examples. | Realism benchmark for vertical AI footage. | none | thread not captured |
| 2026-09-26 | @higgsfield_ai | 826,160 | https://x.com/higgsfield_ai/status/2103875279588602225 | Higgsfield MCP lets Opus 5.5 generate graphics, animate compositions and render, returning an editable After Effects project. | An option when a human finisher needs an editable AE file. | none | brand promo (Higgsfield) |
| 2026-09-10 | @higgsfield_ai | 137,993 | https://x.com/higgsfield_ai/status/2098081141039456756 | Higgsfield Effects 2.0 inside ChatGPT: upload a photo and get an effect video in the chat. | Quick effect clips for social; not for product films. | none | brand promo (Higgsfield) |
| 2026-09-23 | @benjitaylor | 497,477 | https://x.com/benjitaylor/status/2102820884931354776 | Grok Imagine used to generate a consistent set of covers for the new Grokipedia. | Use one image model for a whole cover series to keep style consistent. | none | author appears to work at X (his X Numbers post says 'we') |
| 2026-09-16 | @QuiverAI | 2,335,131 | https://x.com/QuiverAI/status/2100295136261349802 | Arrow 2: QuiverAI's models for generating precise, editable vector graphics, in app and API. | Generate editable vector assets (icons, logos) to animate in code renderers. | none | brand launch |
| 2026-06-11 | @ElevenLabs | 413,896 | https://x.com/ElevenLabs/status/2065129866471551160 | ElevenLabs Avatars in ElevenCreative: talking videos from a script, a voice and an avatar. | Presenter clips without a shoot; voice and face in one tool. | none | brand launch |
| 2026-09-30 | @VivixLabs_HQ | 1,071,298 | https://x.com/VivixLabs_HQ/status/2105329123271033028 | Vivix A1 Playground: live AI characters that talk, move, hold objects and play games, built from a description or photo. | Possible live host or character for demos; capability claims are the vendor's. | https://platform.vivix.ai/vivix-a1-model/ | brand launch |
| 2026-10-01 | @codyschneider | 13,813 | https://x.com/codyschneider/status/2105659003162247485 | Ad pipeline: Reddit pain points via Exa, 15 scripts, ElevenLabs voice, Seedance lip-sync via kie.ai or Higgsfield, batch upload to Meta. | 30s script formula: hook, pain point, desired outcome in simple words; about $2.50 per video per the post. | none | none |
| 2026-08-02 | @shardul_mane | 10,473 | https://x.com/shardul_mane/status/2083737041146372153 | X Article: a supermemory teammate's fully AI-generated ad film for Company Brain: Higgsfield assets, Seedance shots, his own edit. | Make character, location and prop sheets first; one face per character sheet; per-model prompt skills. | https://x.com/i/article/2083350007508549632<br>https://higgsfield.ai/blog/cinematic_headphones<br>https://www.youtube.com/@HiggsfieldAI/videos<br>https://supermemory.ai/brain/ | own company; credits @adilinthewild's workflow |
| 2026-09-16 | @adilinthewild | 1,220,144 | https://x.com/adilinthewild/status/2100333895166337048 | 'The Higgsfield Guy' posts a 34s video promising to 'expose the truth' about Higgsfield. | Teaser-style hook for a tool video; content unclear from the post. | none | likely Higgsfield marketing; content unclear |
| 2026-06-06 | @aashatwt | 31,357 | https://x.com/aashatwt/status/2063314625542996150 | Quoted X Article: a hero section with a holographic avatar animated in Kling as the background video, plus cursor interaction. | Get character angles from an image model, animate in Kling, loop it behind the hero without overlays. | https://x.com/aashatwt/status/2063260427619008751<br>https://x.com/i/article/2063236351328411648 | none |
| 2026-09-07 | @shannholmberg | 25,878 | https://x.com/shannholmberg/status/2096909465757065371 | His model stack for marketing work, including GPT Image 2 for mockups and ads and Seedance 2.5 for 30s campaign videos. | Seedance 2.5 notes: keep product and character consistent across shots; edit one moment by timestamp instead of regenerating. | none | none |
| 2026-09-24 | @RyanZambrano8 | 139,707 | https://x.com/RyanZambrano8/status/2103172206796890379 | Pixero: enter a URL; it learns the brand, finds competitor ads and content, recreates them for your product and deploys. | Competitor-ad remakes as a fast ad source; check rights and originality. | none | promo |
| 2026-09-23 | @theo_louro | 231,279 | https://x.com/theo_louro/status/2102770476233666991 | System combining TrendTrack, Higgsfield and Meta Ads to find competitors' winning ads, analyse hooks and angles, and regenerate them. | Analyse hooks and angles of winning ads before generating variants. | none | non-English (French); comment-for-DM |
| 2026-08-15 | @UseFastlane | 18,790 | https://x.com/UseFastlane/status/2088490678473134317 | Fastlane says it creates thousands of promo videos from a URL ('Tinder for Marketing'), free to use. | Volume tool for social clips; not for crafted films. | https://usefastlane.ai | brand promo |
| 2026-07-02 | @UseFastlane | 1,910,946 | https://x.com/UseFastlane/status/2072575476418404632 | Fastlane pitched as 'Claude for Social Media': promo videos for many social accounts from your website in one click. | Same volume-video idea; 53s launch film. | none | brand promo |

See also, listed in other sections: @willyhopps (2026-08-05, under Code-made video) https://x.com/willyhopps/status/2085033689973711030; @runable_hq (2026-10-03, under Reels) https://x.com/runable_hq/status/2106407527776944555; @Ishansharma7390 (2026-09-13, under Reels) https://x.com/Ishansharma7390/status/2099170895717949910; @byhewar (2026-08-03, under Reels) https://x.com/byhewar/status/2084261110908145666; @DholakiaJaydeep (2026-09-09, under Reels) https://x.com/DholakiaJaydeep/status/2097736024214688145; @Av1dlive (2026-09-10, under Prompts) https://x.com/Av1dlive/status/2098055179761525165; @ky__zo (2026-08-05, under Galleries) https://x.com/ky__zo/status/2085067731230154921; @alexxgrowth (2026-06-21, under Adjacent) https://x.com/alexxgrowth/status/2068795461251781060; @Oluwaphilemon1 (2026-06-12, under Adjacent) https://x.com/Oluwaphilemon1/status/2065307645561438529; @DeRonin_ (2026-06-12, under Adjacent) https://x.com/DeRonin_/status/2065246629699977307; @johncoogan (2026-09-21, under Adjacent) https://x.com/johncoogan/status/2102081954762072431; @PenguinWeb3 (2026-06-06, under Adjacent) https://x.com/PenguinWeb3/status/2063196355011424582.

## Sound and music

Sound-first ideas and code-made audio. 3 bookmarks.

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-09-27 | @LexnLin | 94,454 | https://x.com/LexnLin/status/2104148233106723099 | Claude Code (Opus 5.5) made a 33s launch film for a fake calendar app; name, logo, UI, animation, soundtrack and SFX are all code. | Generate music and SFX in code on the same timeline as the picture. | none | repo link in replies (not captured) |
| 2026-09-29 | @austinh___ | 3,970 | https://x.com/austinh___/status/2104941773420122177 | Unify launch where the team does ASMR (91s 4K, sound on), announcing Unify in Claude, Codex and Cursor. | Sound-first concept: let close-mic sounds carry a launch instead of music. | none | company promo; low reach (4K views) |
| 2026-10-02 | @kunalbagaria | 2,906 | https://x.com/kunalbagaria/status/2105992661903761572 | Rustyvibes: a macOS menu-bar app that gives any keyboard a mechanical sound. | Possible source of typing sounds for screen-recorded demos; recording quality unclear. | https://rustyvibes.kunalbagaria.com | low reach |

See also, listed in other sections: @RaphaelAubryy (2026-09-28, under Code-made video) https://x.com/RaphaelAubryy/status/2104502744010629269; @lennysan (2026-07-29, under Reels) https://x.com/lennysan/status/2082502439597678688; @LexnLin (2026-10-02, under Reels) https://x.com/LexnLin/status/2106101651010449796; @rossaxbt (2026-10-04, under Prompts) https://x.com/rossaxbt/status/2106758817161597021; @rossaxbt (2026-10-03, under Transitions) https://x.com/rossaxbt/status/2106396375269134597; @ElevenLabs (2026-06-11, under AI tools) https://x.com/ElevenLabs/status/2065129866471551160; @codyschneider (2026-10-01, under AI tools) https://x.com/codyschneider/status/2105659003162247485.

## YouTube and thumbnails

Channel and episode formats. No bookmark is about thumbnails directly; see the GPT Images 2.5 course for a thumbnail brief example. 4 bookmarks.

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-08-10 | @Bencera | 506,903 | https://x.com/Bencera/status/2086855424318337191 | Polsia's founder says starting a YouTube channel was his highest-leverage growth move; episode 4 of his documented journey (15 min, 4K). | Document-the-journey episodes as a channel format. | none | none |
| 2026-08-20 | @juliafedorin | 15,747 | https://x.com/juliafedorin/status/2090277291507253632 | a16z's head of creators follows people who visibly improve: camera, then storytelling, then whole new formats. | Let the channel show growth in craft; share interests outside the niche. | none | none |
| 2026-07-24 | @supermemory | 14,756 | https://x.com/supermemory/status/2080542605360902263 | 'Meet the minds building supermemory' episode (20 min): Prasanna on how memory works in the brain and in AI. | Team-episode format with a pull-quote in the copy. | none | own company |
| 2026-07-17 | @juliafedorin | 19,391 | https://x.com/juliafedorin/status/2078132625479254521 | Street-style interview with Dhravya at an event (6.4 min) with chapter timestamps. | Event pop-up interview format with chapters. | none | about own company |

See also, listed in other sections: @nidhisinghattri (2026-09-11, under Code-made video) https://x.com/nidhisinghattri/status/2098453574573539807; @Av1dlive (2026-09-10, under Prompts) https://x.com/Av1dlive/status/2098055179761525165; @GanatraSoham (2026-08-07, under Adjacent) https://x.com/GanatraSoham/status/2085830675224240400.

## Adjacent

Useful around the edges: short-form and UGC, 3D, graph visuals, assets and formats, plus other launch posts with a video. 59 bookmarks.

### Short-form, UGC and launch playbooks

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-08-23 | @irabukht | 72,045 | https://x.com/irabukht/status/2091650931951558813 | Thread on why in-house UGC fails, with costs and fixes, ending in Seedance plus Claude for faces and demos. | Ask creators for face or reaction takes only; shoot demos and edit in-house; aim between pure demo and entertainment. | none | none |
| 2026-09-01 | @yoyozhang06 | 263,466 | https://x.com/yoyozhang06/status/2094801751287201951 | UGC lead who grew a campaign past 200M views a month explains what startups get wrong (63s video). | UGC lessons are in the video; text gives only the claim. | none | content in video only |
| 2026-08-07 | @GanatraSoham | 20,048 | https://x.com/GanatraSoham/status/2085830675224240400 | Composio's 19-year-old social hire: first video hit 4M views; creator program grew to 100 creators and 150M views. | Hire a native short-form creator and give them budget. | none | none |
| 2026-06-21 | @alexxgrowth | 35,940 | https://x.com/alexxgrowth/status/2068795461251781060 | Points to Syndicate, an agency claiming $4M generated and 752M views from faceless and AI content. | Faceless AI content as a format; claims are the agency's. | none | agency promo |
| 2026-09-21 | @leojrr | 166,589 | https://x.com/leojrr/status/2102060095265735085 | Quoted X Article: using Jev with Virlo to find hooks, formats and angles in viral TikToks and turn them into scripts. | Score hooks of niche short videos before scripting your own. | https://x.com/i/article/2102004103240904704<br>https://virlo.ai/?via=jev<br>https://dev.virlo.ai/?via=jev | affiliate links (virlo.ai ?via=jev); hype |
| 2026-07-20 | @askOkara | 46,970 | https://x.com/askOkara/status/2079145745756934552 | Okara announces a handbook on running viral X launches (100M+ views claimed, no agency or ads). | Launch-ops checklist source once published. | none | self-promo; comment-for-DM |
| 2026-06-22 | @askOkara | 80,361 | https://x.com/askOkara/status/2068973408357142742 | Okara thread of growth playbooks, including UGC videos and getting 100K-1M views on launch videos. | Launch-video distribution playbook lives in the thread. | none | self-promo; thread not captured |
| 2026-08-20 | @askOkara | 7,870 | https://x.com/askOkara/status/2090406857680761133 | Okara's written playbook for launching on X with their influencer agent. | Distribution side of launch films. | none | self-promo; guide link not in the post |

### 3D for video

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-09-21 | @AmirMushich | 366,273 | https://x.com/AmirMushich/status/2102110980855484589 | 20 listing photos turned into a walkable 3D space in Unreal Engine 5.8 with GPT-6 Astra; Google Maps panoramas for the exterior. | Photo-to-3D environments for camera fly-throughs. | none | process offered on request, not shared |
| 2026-09-06 | @Emanuel_Andre7 | 1,005,863 | https://x.com/Emanuel_Andre7/status/2096528986390085696 | GPT-6 Astra built an interactive 3D ankle atlas with motion sliders and live ligament readouts in one session. | Interactive 3D explainers as source footage for science-style films. | none | none |
| 2026-06-12 | @Oluwaphilemon1 | 95,088 | https://x.com/Oluwaphilemon1/status/2065307645561438529 | Quoted workflow: product image from the Magnific MCP, converted to a 3D model, then Fable 5 builds an interactive product page. | Image-to-3D path for product hero shots. | https://x.com/Oluwaphilemon1/status/2064940105802907685 | main post is a Claude usage tip; 3D workflow is in the quote |
| 2026-06-11 | @anshuc | 133,383 | https://x.com/anshuc/status/2064959907833803261 | Fable turned food photos into Gaussian splats on a virtual dining table inside a vibe-coded calorie tracker. | Gaussian splats as a premium 3D look for product shots. | https://x.com/anshuc/status/2064829593782210844 | none |
| 2026-06-12 | @DeRonin_ | 6,792 | https://x.com/DeRonin_/status/2065246629699977307 | Higgsfield Games: describe a 2D or 3D game; characters, props and settings come from the Higgsfield MCP. | Generated 3D characters and props as possible film assets. | none | promo-style post |

### Graph and network visuals

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-06-05 | @humzaakhalid | 340,557 | https://x.com/humzaakhalid/status/2062890023553576971 | 64s video of an Obsidian graph presented as Karpathy's vault, nodes and links animating. | Graph-view motion reference for memory-graph films; the Karpathy claim is unverified. | https://obsidian.md/ | engagement bait; unverified claims |
| 2026-06-06 | @humzaakhalid | 41,869 | https://x.com/humzaakhalid/status/2063256051139621157 | Earlier post with the same Obsidian-graph framing (43s video) and a comment-for-guide ask. | Same graph reference as his Jun 5 post. | none | engagement bait; near-duplicate |
| 2026-08-25 | @VibeMarketer_ | 57,665 | https://x.com/VibeMarketer_/status/2092275405323690083 | 30s video of a code knowledge graph (files as nodes, imports as edges) pitched as the model for a company brain. | Click-to-trace node navigation shots for memory or context graphs. | https://x.com/i/article/2092243366759235586<br>https://www.hqforwork.com/r/vibe-marketer | referral link (hqforwork) |
| 2026-06-11 | @hxyden | 85,530 | https://x.com/hxyden/status/2065118972790612368 | 'Obsidian for your app': a spatial graph of an app's screens, used to reconstruct a real user flow (44s). | Screen-graph layout as a way to show product breadth. | none | none |
| 2026-06-19 | @vedx09 | 316 | https://x.com/vedx09/status/2067883460648407123 | Screenshot of the supermemory plugin's node graph in Codex. | How the supermemory graph looks to users; reference for graph scenes. | none | own product; low reach |

### Assets, brand QA, formats and misc

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-09-22 | @raroque | 143,865 | https://x.com/raroque/status/2102465007476728136 | Idea: Claude Code automatically creates screenshots every time you push a feature (10s demo). | Automate fresh product stills per release to feed changelog films. | none | none |
| 2026-07-26 | @chddaniel | 21,819 | https://x.com/chddaniel/status/2081408739656278442 | 'Claude for Cloning': clone a website or app with pixel-perfect accuracy. | Rebuilding real UI precisely is the same need as vector console scenes; verify accuracy claims. | none | promo |
| 2026-07-21 | @supermemory | 9,931 | https://x.com/supermemory/status/2079427676461490506 | supermemory post with a code-window graphic on a blue gradient for the simpler search API. | Brand code-card style reference for code moments in films. | none | own company |
| 2026-08-31 | @reynardthefox_ | 3,365 | https://x.com/reynardthefox_/status/2094448309129953537 | Tool list including Moda for decks and graphics and Melius for ads and UGC. | Two visual tools worth a look; the rest are not video-related. | none | tool list |
| 2026-10-03 | @thesherlocker | 8,807 | https://x.com/thesherlocker/status/2106443936848064654 | X Article of weekend AI builds, including a brand design skill checked by a verifier subagent until designs match the spec. | Brand QA loop: guidelines become a skill; a verifier agent checks samples until they match. | https://x.com/i/article/2106435679496671232 | none |
| 2026-09-21 | @johncoogan | 406,462 | https://x.com/johncoogan/status/2102081954762072431 | 'Video is solved' with a 30s clip from the TBPN host. | What the clip shows is unclear from the post. | none | content unclear |
| 2026-07-03 | @StackDhruv | 23,976 | https://x.com/StackDhruv/status/2072882634896936968 | A custom 68s demo built for @heyclicky and addressed to @FarzaTV, his third attempt to get noticed. | Spec demo video as outreach. | none | none |
| 2026-06-17 | @DannPetty | 24,029 | https://x.com/DannPetty/status/2067239384714248512 | Someone made a 2-minute video just to get one person's attention for a job. | Video as a targeted pitch format. | none | none |
| 2026-06-06 | @PenguinWeb3 | 18,793,674 | https://x.com/PenguinWeb3/status/2063196355011424582 | A ChatGPT image prompt that asks to 'restore' a photo that doesn't exist, producing eerie, made-up images. | Hallucinated 'lost media' look as an aesthetic; prompt is in the post. | none | community note: copied without credit (earlier post by @icreatelife) |

### Other launch posts with a video (rule-based)

Product launches whose post carries a video of 15s or more and reached 100K+ views. The posts don't discuss how the film was made; they are here as length and format references, sorted by views. Video lengths here run 20s to 198s (median 65s).

| date | @author | views | link | what it is | what to take for her videos | resources linked in the post | flags |
|---|---|---|---|---|---|---|---|
| 2026-08-10 | @Altimor | 7,809,120 | https://x.com/Altimor/status/2086861887611019623 | Launch post: Lindy Teammate, an AI employee you message in Slack. Video 94s, 3840x2160. | Format and length reference; the post does not discuss the film's craft. | https://lindy.ai | included by rule (video of 15s+, 100K+ views) |
| 2026-09-10 | @OpenAIDevs | 7,430,782 | https://x.com/OpenAIDevs/status/2098099269551149398 | Launch post: GPT-Live-1 voice model in the API. Video 77s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | none | AI model/API launch; included by rule (video of 15s+, 100K+ views) |
| 2026-09-21 | @X | 5,419,635 | https://x.com/X/status/2102147636702634195 | Launch post: X's 'timeline. ticker. trade.' three-word brand film. Video 40s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-08-10 | @SpotifyEng | 5,259,291 | https://x.com/SpotifyEng/status/2086795659651191106 | Launch post: Spotify's Xirp agentic development environment. Video 65s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | http://xirp.spotify.com | included by rule (video of 15s+, 100K+ views) |
| 2026-09-10 | @cursor_ai | 2,989,686 | https://x.com/cursor_ai/status/2098162488013455784 | Launch post: Cursor Projects, a persistent coordinator agent. Video 94s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-08-17 | @NousResearch | 2,543,795 | https://x.com/NousResearch/status/2089429432612147572 | Launch post: Bot Mode for Hermes Desktop. Video 90s, 4096x2302. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-09-22 | @gaganbiyani | 2,302,283 | https://x.com/gaganbiyani/status/2102404344351973825 | Launch post: The Horowitz Andreessen Academy school launch. Video 117s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | https://www.theacademysf.com/ | included by rule (video of 15s+, 100K+ views) |
| 2026-08-17 | @askOkara | 2,067,153 | https://x.com/askOkara/status/2089366669613531602 | Launch post: Okara AI CMO v2. Video 67s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | https://okara.ai | self-promo (Okara); included by rule (video of 15s+, 100K+ views) |
| 2026-09-21 | @Bouazizalex | 2,033,236 | https://x.com/Bouazizalex/status/2102127902510944722 | Launch post: Akai, Deel's internal automation tool, launched publicly. Video 198s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | https://www.akai.run | long founder demo; included by rule (video of 15s+, 100K+ views) |
| 2026-07-28 | @aidangch | 1,884,207 | https://x.com/aidangch/status/2082134857862578585 | Launch post: Attention Inc: 'we're recording it'. Video 50s, 3840x2160. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-09-16 | @rshanreddy | 1,415,962 | https://x.com/rshanreddy/status/2100280703825137932 | Launch post: Aristotle AI tutor, opening on a US-vs-China education hook. Video 139s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | https://heyaristotle.com | included by rule (video of 15s+, 100K+ views) |
| 2026-09-16 | @MeredithCheng22 | 1,266,860 | https://x.com/MeredithCheng22/status/2100274697162104862 | Launch post: ToneBird, after a founder's pivot story. Video 103s, 3840x2160. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-09-16 | @tlxue | 1,162,779 | https://x.com/tlxue/status/2100288496170574284 | Launch post: Rene, a multiplayer iMessage agent. Video 56s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-09-14 | @cline | 1,008,272 | https://x.com/cline/status/2099536235350086029 | Launch post: Cline Desktop for open-weights models. Video 32s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-08-19 | @GTE_XYZ | 974,761 | https://x.com/GTE_XYZ/status/2090112858767917184 | Launch post: GTE's 'We're back.' return film. Video 72s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | https://gte.xyz | included by rule (video of 15s+, 100K+ views) |
| 2026-08-27 | @shengkunye | 885,987 | https://x.com/shengkunye/status/2093050916953903451 | Launch post: Free agent web search ('we just killed Exa...'). Video 35s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-08-20 | @ExaAILabs | 807,620 | https://x.com/ExaAILabs/status/2090472683758841932 | Launch post: Exa plugin in Codex and ChatGPT. Video 23s, 1920x1440. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-09-22 | @benjitaylor | 758,905 | https://x.com/benjitaylor/status/2102443951898992825 | Launch post: X Numbers rollout. Video 31s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | none | author appears to work at X; included by rule (video of 15s+, 100K+ views) |
| 2026-08-25 | @OriSilver | 697,158 | https://x.com/OriSilver/status/2092225524210827424 | Launch post: Maxfusion 'Marketing AGI' open-sourced playbook. Video 37s, 2160x2160. | Format and length reference; the post does not discuss the film's craft. | none | comment-for-DM; included by rule (video of 15s+, 100K+ views) |
| 2026-07-21 | @whop | 671,752 | https://x.com/whop/status/2079582424250323162 | Launch post: Whop CLI. Video 20s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-08-11 | @jasonzhou1993 | 621,374 | https://x.com/jasonzhou1993/status/2087138389770514867 | Launch post: 'OpenRouter for tools' marketplace. Video 49s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | https://treg.superdesign.dev/ | included by rule (video of 15s+, 100K+ views) |
| 2026-06-18 | @perplexity_ai | 612,226 | https://x.com/perplexity_ai/status/2067642139014742348 | Launch post: Perplexity's Brain in Computer memory system. Video 66s, 3840x2160. | Format and length reference; the post does not discuss the film's craft. | none | competitor in memory; included by rule (video of 15s+, 100K+ views) |
| 2026-08-17 | @Mutchtaba2 | 534,927 | https://x.com/Mutchtaba2/status/2089385271896822197 | Launch post: Straitly zero-markup AI gateway. Video 80s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | http://straitly.ai | included by rule (video of 15s+, 100K+ views) |
| 2026-09-16 | @pierre_dlgr | 505,704 | https://x.com/pierre_dlgr/status/2100259806036566360 | Launch post: AI workers startup's EUR 10M raise. Video 66s, 848x480. | Format and length reference; the post does not discuss the film's craft. | none | funding announcement; included by rule (video of 15s+, 100K+ views) |
| 2026-09-28 | @wabi | 488,512 | https://x.com/wabi/status/2104721766690222087 | Launch post: Wabi 2.0 messenger that makes apps. Video 80s, 3840x2160. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-06-16 | @Ozacle23 | 440,714 | https://x.com/Ozacle23/status/2066838399508709464 | Launch post: minimi 'company brain' for Claude. Video 145s, 3840x2160. | Format and length reference; the post does not discuss the film's craft. | http://projectminimi.com/brain | same space as supermemory; included by rule (video of 15s+, 100K+ views) |
| 2026-09-21 | @irabukht | 287,313 | https://x.com/irabukht/status/2102158706041659578 | Launch post: Muse for Marketing (connects ad and SEO tools). Video 29s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | http://ryze.ai/muse | included by rule (video of 15s+, 100K+ views) |
| 2026-08-18 | @Crowdreply_io | 267,370 | https://x.com/Crowdreply_io/status/2089729369644417171 | Launch post: CrowdReply SuperAgent for AI-answer ranking. Video 53s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-08-13 | @SeijinJung | 213,714 | https://x.com/SeijinJung/status/2087909540679540898 | Launch post: Helena MCP for ad accounts. Video 38s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | http://enrichlabs.ai/mcp | included by rule (video of 15s+, 100K+ views) |
| 2026-08-24 | @Jasperli0122 | 146,400 | https://x.com/Jasperli0122/status/2091933555954000213 | Launch post: Monid tool marketplace for agents. Video 42s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-08-18 | @safishamsii | 130,514 | https://x.com/safishamsii/status/2089748658157670454 | Launch post: graphify knowledge-graph engine launch. Video 80s, 1440x1080. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |
| 2026-09-23 | @leodev | 124,504 | https://x.com/leodev/status/2102781872107659270 | Launch post: Social SDK, open source, 7 platforms. Video 56s, 1920x1080. | Format and length reference; the post does not discuss the film's craft. | none | included by rule (video of 15s+, 100K+ views) |

## Resource index

Every external URL linked from the kept bookmarks (post text, X Article or quoted post), deduplicated. Newsletter-signup, Telegram, profile and tracking links are left out. Descriptions come from the posts themselves.

### Code-video skills, repos and docs

- https://github.com/howseen-ai/claude-motion-design: Open-source Claude Code skill packaging a full motion-video pipeline: flow, render and audio scripts, critique loop, example source. From @RaphaelAubryy (2026-09-28).
- https://gist.github.com/dabit3/5d3969b61db56dc150c161b46350584a: Prompt for agent-recorded product tutorials. From @dabit3 (2026-09-28).
- https://www.remotion.dev/docs/the-fundamentals: Remotion fundamentals docs, linked in the Motion Engineering article. From @rossaxbt (2026-10-04), @rossaxbt (2026-10-03).
- https://github.com/heygen-com/hyperframes/blob/main/docs/developers/overview.mdx: HyperFrames developer overview, linked in the Motion Engineering article. From @rossaxbt (2026-10-04), @rossaxbt (2026-10-03).
- https://github.com/heygen-com/hyperframes-community-skills/tree/master/skills/camera-3d-captions: HyperFrames community skill for a 3D camera move with captions. From @jake11moran (2026-09-22).
- http://tushaarmehtaa.xyz/skill: /remove-ai-slop skill for AI tells in design and copy. From @tushaarmehtaa (2026-06-20).
- http://emilkowal.ski/skill: Emil Kowalski's /review-animations and /emil-design-eng animation skills. From @tushaarmehtaa (2026-06-20).

### Galleries and design references

- https://okara.ai/launch-library: Hundreds of X launch examples in one place (Okara). From @askOkara (2026-10-01).
- https://supermemory.ai: supermemory's site (her company). From @theCTO (2026-09-08), @Muskanjain0401 (2026-10-01).
- http://scrolltide.co: 300+ award-level website prompts with downloadable source (the post's top pick). From @himanshubuildss (2026-10-03).
- http://designmd.ai: Design systems written as markdown an agent can read. From @himanshubuildss (2026-10-03).
- http://vibeprompts.dev: Ready-made prompts for dashboards and landing pages. From @himanshubuildss (2026-10-03).
- http://minimal.gallery: Curated high-end websites. From @himanshubuildss (2026-10-03).
- http://kage.design: Real UI inspiration mapped to prompts. From @himanshubuildss (2026-10-03).
- http://styles.refero.design: 2,000+ real product styles with typography; also on the DESIGN.md list. From @himanshubuildss (2026-10-03), @noahelhadedy (2026-09-13).
- http://component.gallery: 2,600+ examples of how design systems solve the same element. From @himanshubuildss (2026-10-03).
- http://godly.website: Curated collection of striking websites. From @himanshubuildss (2026-10-03).
- http://awwwards.com: Ranked web design awards. From @himanshubuildss (2026-10-03).
- http://landing.love: Showcase of animation-heavy websites. From @himanshubuildss (2026-10-03).
- http://land-book.com: Curated landing pages. From @himanshubuildss (2026-10-03).
- http://mobbin.com: Mobile design patterns. From @himanshubuildss (2026-10-03).
- http://hoverstat.es: Experimental web design projects. From @himanshubuildss (2026-10-03).
- http://navbar.gallery: Navigation patterns. From @himanshubuildss (2026-10-03).
- http://footer.design: Footer layouts. From @himanshubuildss (2026-10-03).
- http://cta.gallery: Forms, popups and buttons. From @himanshubuildss (2026-10-03).
- http://supahero.io: Curated hero sections. From @himanshubuildss (2026-10-03).
- http://pricingpages.design: Pricing page examples. From @himanshubuildss (2026-10-03).
- https://designeer.xyz: Curated interface craft, component libraries and AI tools (name read from the screenshot). From @amanbehumble (2026-10-03).
- https://typeui.sh: Listed as a DESIGN.md site. From @noahelhadedy (2026-09-13).
- https://designmd.me: Listed as a DESIGN.md site. From @noahelhadedy (2026-09-13).
- https://designmd.supply: Listed as a DESIGN.md site. From @noahelhadedy (2026-09-13).
- https://getdesign.md: Listed as a DESIGN.md site (written as plain text, not linked). From @noahelhadedy (2026-09-13).
- https://collectui.com: On both the DESIGN.md list and the mobile-inspiration list. From @noahelhadedy (2026-09-13), @noahelhadedy (2026-09-12).
- https://designmd-store.com: Listed as a DESIGN.md site. From @noahelhadedy (2026-09-13).
- https://appshots.design: Listed as a mobile app inspiration site. From @noahelhadedy (2026-09-12).
- https://screensdesign.com: Listed as a mobile app inspiration site. From @noahelhadedy (2026-09-12).
- https://refero.design: Listed as a mobile app inspiration site. From @noahelhadedy (2026-09-12).
- https://pageflows.com: Listed as a mobile app inspiration site. From @noahelhadedy (2026-09-12).
- https://gummble.com: Listed as a mobile app inspiration site. From @noahelhadedy (2026-09-12).
- https://revyl.com: Listed as a mobile app inspiration site. From @noahelhadedy (2026-09-12).
- http://adilmania.com: Minimal personal site. From @adilmania (2026-07-06).
- https://contact.parallel.ai: Parallel's contact form, a micro-interaction reference. From @lukaslevert (2026-09-29).
- https://gracewang.design: Portfolio site with a fishing interaction. From @gracewangdesign (2026-09-11).
- https://shyglass.app: Small privacy app shown in a 9.5s vertical demo. From @MaxRovensky (2026-09-19).

### Component, animation, shader and 3D libraries

- http://21st.dev: Community component marketplace that plugs into agents via MCP. From @himanshubuildss (2026-10-03).
- http://ui.shadcn.com: shadcn/ui components. From @himanshubuildss (2026-10-03).
- http://ui.aceternity.com: 200+ animated React and Tailwind components. From @himanshubuildss (2026-10-03).
- http://magicui.design: 150+ animated components and effects. From @himanshubuildss (2026-10-03).
- http://motion-primitives.com: Advanced interaction components. From @himanshubuildss (2026-10-03).
- http://uiverse.io: Open-source UI elements. From @himanshubuildss (2026-10-03).
- http://smoothui.dev: Animated components built on Motion and GSAP. From @himanshubuildss (2026-10-03).
- http://shadcnblocks.com: 2,000+ pre-built section blocks for shadcn/ui. From @himanshubuildss (2026-10-03).
- http://kinetics.colorion.co: 150+ motion effects with React code and prompts. From @himanshubuildss (2026-10-03).
- http://microkit.co: Micro-interactions. From @himanshubuildss (2026-10-03).
- http://glass.samasante.com: Glass refraction components. From @himanshubuildss (2026-10-03).
- http://animejs.com: Lightweight animation engine. From @himanshubuildss (2026-10-03).
- http://threejs.org: Web 3D library. From @himanshubuildss (2026-10-03).
- http://shadertoy.com: Online shader editor and community. From @himanshubuildss (2026-10-03).
- http://thebookofshaders.com: Free interactive introduction to fragment shaders. From @himanshubuildss (2026-10-03).
- http://threejs-journey.com: Three.js course with shader chapters. From @himanshubuildss (2026-10-03).
- http://kitbitz.art: 2,000+ hand-drawn illustrations. From @himanshubuildss (2026-10-03).
- http://3dicons.co: 3D icons. From @himanshubuildss (2026-10-03).
- https://obsidian.md/: Obsidian, whose graph view appears in the vault videos. From @humzaakhalid (2026-06-05).

### AI, coding and video tools

- https://devin.ai/: Devin, the cloud agent used to record the tutorials. From @dabit3 (2026-09-28).
- https://supermemory.ai/docs/supermemory-mcp/mcp: supermemory MCP docs. From @DhravyaShah (2026-07-31).
- https://developers.openai.com/api/docs/guides/image-prompting?model=gpt-image-2.5: OpenAI's image-prompting guide for GPT Image 2.5. From @Av1dlive (2026-09-10).
- http://claude.com/product/claude-code: Claude Code, the command-line AI coding agent. From @himanshubuildss (2026-10-03).
- http://cursor.com: Cursor, an AI-first code editor. From @himanshubuildss (2026-10-03).
- http://v0.dev: Vercel's prompt-to-component tool. From @himanshubuildss (2026-10-03).
- http://lovable.dev: AI app builder in the browser. From @himanshubuildss (2026-10-03).
- https://platform.vivix.ai/vivix-a1-model/: Vivix A1 live AI characters. From @VivixLabs_HQ (2026-09-30).
- https://higgsfield.ai/blog/cinematic_headphones: Higgsfield blog post the author points to for @adilinthewild's workflow and skills. From @shardul_mane (2026-08-02).
- https://www.youtube.com/@HiggsfieldAI/videos: Higgsfield's YouTube walkthroughs on AI filmmaking. From @shardul_mane (2026-08-02).
- https://supermemory.ai/brain/: supermemory Company Brain page. From @shardul_mane (2026-08-02).
- https://usefastlane.ai: Fastlane, bulk promo-video generator. From @UseFastlane (2026-08-15).
- https://rustyvibes.kunalbagaria.com: macOS menu-bar app that gives any keyboard a mechanical sound. From @kunalbagaria (2026-10-02).
- https://virlo.ai/?via=jev: Virlo, paired with Jev for viral short-video research (referral link). From @leojrr (2026-09-21).
- https://dev.virlo.ai/?via=jev: Virlo developer site (referral link). From @leojrr (2026-09-21).
- https://www.hqforwork.com/r/vibe-marketer: HQ, referral link in the company-brain article. From @VibeMarketer_ (2026-08-25).

### Launch films and reference posts

- https://x.com/RaphaelAubryy/status/2104178266990858739: Baguette launched like an Apple product: white background, classical music, real crunch SFX. From @RaphaelAubryy (2026-09-28).
- https://x.com/RaphaelAubryy/status/2103500173909356632: Paper-zine K-pop remake of a music video's opening. From @RaphaelAubryy (2026-09-28).
- https://x.com/RaphaelAubryy/status/2104300246268571733: 24s Howseen launch video built with the same pipeline. From @RaphaelAubryy (2026-09-28).
- https://x.com/jake11moran/status/2084381821685657863: Post carrying the Lenny's Product Pass workflow article. From @jake11moran (2026-08-03).
- https://intelligence.co/: intelligence.co, cited for its slow, calm launch film. From @filippocarnvl (2026-09-10).
- https://x.com/ndrewpignanelli/status/2051323944452411773: Linked in the Epta article's intelligence.co example; likely that launch film (unclear). From @filippocarnvl (2026-09-10).
- https://x.com/AkshayNarisetti/status/2077439335130124544: Pocket's 90s launch film. From @filippocarnvl (2026-09-10), @AkshayNarisetti (2026-07-18).
- https://lnkd.in/p/ew9iCKd5: LinkedIn short link in the Epta article; target unclear. From @filippocarnvl (2026-09-10).
- https://cal.com/eptastudios/introduction-call-with-epta: Epta Studios booking link (self-promo). From @filippocarnvl (2026-09-10).
- https://x.com/tjcages/status/1976657115633868884: 'New Cloudflare' rebrand launch video by @tjcages. From @titouangillet_ (2026-09-11).
- https://www.lennysproductpass.com/: Lenny's Product Pass, the subject of the one-shot launch video. From @lennysan (2026-07-29).
- https://www.lennysnewsletter.com/p/productpass-summer2026launch: Product Pass announcement post. From @lennysan (2026-07-29).
- https://sidehoe.chat: Sidehoe, the parody launch. From @maximusgrave (2026-09-23).
- http://billpaythemusical.com: Ramp's Broadway musical stunt. From @eglyman (2026-09-10).
- https://x.com/jake11moran/status/2102493361743839432: 19s demo of the 3D camera and text effect. From @jake11moran (2026-09-22).
- https://x.com/dhruvtwt_/status/2075091446198382650: Part 1 of the favourite design engineers grid. From @dhruvtwt_ (2026-07-12).
- https://x.com/aashatwt/status/2063260427619008751: Post carrying the hero-section article. From @aashatwt (2026-06-06).
- https://x.com/Oluwaphilemon1/status/2064940105802907685: 3D product website workflow with prompts. From @Oluwaphilemon1 (2026-06-12).
- https://x.com/anshuc/status/2064829593782210844: '100x the design' update with how-to details. From @anshuc (2026-06-11).

### Products from launch posts

- http://Zaro.ai: Zaro workspace. From @adxtyahq (2026-06-25), @ZaroAI_ (2026-06-25).
- https://tryemployable.ai: Her job auto-apply tool. From @Muskanjain0401 (2026-08-17).
- https://onkeiki.com: Keiki, partner in the supermemory x Keiki launch. From @theCTO (2026-09-08).
- http://SMFS.ai: SMFS research site (supermemory). From @DhravyaShah (2026-06-12).
- https://lindy.ai: Lindy Teammate. From @Altimor (2026-08-10).
- http://xirp.spotify.com: Spotify Xirp. From @SpotifyEng (2026-08-10).
- https://www.theacademysf.com/: The Horowitz Andreessen Academy. From @gaganbiyani (2026-09-22).
- https://okara.ai: Okara AI CMO. From @askOkara (2026-08-17).
- https://www.akai.run: Akai. From @Bouazizalex (2026-09-21).
- https://heyaristotle.com: Aristotle AI tutor. From @rshanreddy (2026-09-16).
- https://gte.xyz: GTE. From @GTE_XYZ (2026-08-19).
- https://treg.superdesign.dev/: 'OpenRouter for tools' marketplace. From @jasonzhou1993 (2026-08-11).
- http://straitly.ai: Straitly AI gateway. From @Mutchtaba2 (2026-08-17).
- http://projectminimi.com/brain: minimi company brain. From @Ozacle23 (2026-06-16).
- http://ryze.ai/muse: Muse for Marketing. From @irabukht (2026-09-21).
- http://enrichlabs.ai/mcp: Helena MCP. From @SeijinJung (2026-08-13).

### Other

- https://howseen.ai: The article author's AI-visibility SaaS (self-promo). From @RaphaelAubryy (2026-09-28).

### X Articles linked from kept bookmarks

- https://x.com/i/article/2105626165704572928: Motion Engineering: Build a Video Studio Around Opus 5.5 (by @0xwhrrari). From @rossaxbt (2026-10-04), @rossaxbt (2026-10-03).
- https://x.com/i/article/2104303014542512128: I made 10+ motion videos with Opus 5.5 in 3 days: the whole pipeline (open source). From @RaphaelAubryy (2026-09-28).
- https://x.com/i/article/2084363820752109568: How I made the Lenny's Product Pass video. From @jake11moran (2026-08-03).
- https://x.com/i/article/2103573841176141824: Automating Exceptional Product Tutorials at Scale with Devin. From @dabit3 (2026-09-28).
- https://x.com/i/article/2098106886893830144: Why Your Launch Video Won't Get You Customers In 2026. From @filippocarnvl (2026-09-10).
- https://x.com/i/article/2098012383679819776: How to Master ChatGPT Images 2.5 (Full Course). From @Av1dlive (2026-09-10).
- https://x.com/i/article/2083350007508549632: Here's how you can make your first fully AI-generated ad. From @shardul_mane (2026-08-02).
- https://x.com/i/article/2063236351328411648: How not to make AI slop sites. From @aashatwt (2026-06-06).
- https://x.com/i/article/2102004103240904704: Jev is INSANE for Marketing. From @leojrr (2026-09-21).
- https://x.com/i/article/2106435679496671232: Things to do with AI over the weekend. From @thesherlocker (2026-10-03).
- https://x.com/i/article/2092243366759235586: How to Build a Company Brain That Gets Smarter Every Week (not video-specific). From @VibeMarketer_ (2026-08-25).

### Named in posts but not linked

Mixkit and Pexels (free music, SFX and stock footage in @rossaxbt's launch prompt); HyperFrames (@HyperFrames_); Higgsfield and its MCP; Seedance 2.0 and 2.5, Dreamina; Kling; MiniMax; kie.ai; ElevenLabs; GPT Image 2 and 2.5; Grok Imagine; video-use; vugola MCP; Cutroom (a personal tool); TrendTrack; Pixero; Magnific MCP; Unreal Engine 5.8; Gemini agentic video understanding; Moda and Melius.

