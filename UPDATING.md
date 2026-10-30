# Updating the Cast Recruiter

Run every command from the repo root in a WSL terminal (`cd ~/projects/m3_toolkit`).
From Windows the folder is `\\wsl.localhost\Ubuntu\home\harvey\projects\m3_toolkit`.

## What changed → what to do

| You changed… | Run (steps below) | Deploy |
|---|---|---|
| Card text or stats in the sheet | nothing — the web app reads the sheet live | nothing |
| Dominion rules, statuses, terrain, totems (master sheet's `Dominions` tab) | nothing — the web app reads that tab live | nothing |
| A keyword definition (Player Handbook's `Glossary of Terms`) | nothing — the web app reads the handbook Doc live | nothing |
| A new handbook version saved as a new Doc | change `HANDBOOK_DOC_ID` in `webapp/main.gs` to the new Doc's ID | web app |
| …and the text uses an icon not used before | 1, 2, 3, 2 | web app |
| Card names, IDs, classes, or added / removed / reordered rows | 1, 2, 4, 5 | web app, TTS deck (+ models if IDs or classes changed) |
| New card art (new Dextrous export) | 0, 2, 4, 5 (and 1 first if the sheet changed) | web app, TTS deck |
| An icon SVG or the footer logo | 3 | web app |
| Colours in `webapp/CastRecruiter.html` | 6 | web app |
| A TTS Lua script | — | re-paste it in TTS |

Plain text edits need nothing because the web app pulls card text straight from the `IN Cast` tab.
The Dominion Rules section reads the master sheet's `Dominions` tab by ID (`DOMINIONS_SPREADSHEET_ID` in `main.gs`).
Keyword pop-ups (hover or tap a bold ALL-CAPS keyword) read the handbook's glossary by ID (`HANDBOOK_DOC_ID`); only ALL-CAPS terms are used, and each entry's first sentence (the flavour opener) is left out.
Steps 1 and 2 are still a cheap check after any sheet edit.

## Steps

Each step number matches its script in `dextrous/01_Scripts/` (step 2 is `02_validate_cast.py`, and so on).

`dextrous/` itself holds only the data:
- `MonuMentuM DD-MM-YYYY - Raw.json`: the export exactly as Dextrous made it. Never edited.
- `MonuMentuM DD-MM-YYYY - Processed.json`: the same deck with names, IDs and classes stamped in by step 4. This is the one TTS gets.
- `contact_sheet.html`: step 5's art-next-to-name check, built from the processed deck.

0. **Add the Dextrous export.** Save `MonuMentuM DD-MM-YYYY.json` into `dextrous/` under the name
   Dextrous gives it. The next script to run renames it `... - Raw.json`. The scripts use the newest
   date automatically, so older Raw/Processed pairs can be deleted.
1. **Pull the CSV.** `python3 dextrous/01_Scripts/01_pull_cast.py`. It copies the master sheet's `Cast` tab from
   the M3 Source Exporter's Drive output (refreshed every 15 minutes) over `M3_TTS_DB - Cast.csv`,
   and prints when the sheet was last exported and which cards changed. If you edited the sheet in
   the last 15 minutes and the "exported" time is older than your edit, run `pullNow` in the
   [exporter's Apps Script editor](https://script.google.com/d/1LdQRaCYG7Mbj0KgdNTRHIHaTHH9uyXGc8GEJlTVRHoBZxMx0eEwjrNpK/edit)
   and pull again. If it says G: is unmounted, run the remount command it prints.
2. **Validate.** `python3 dextrous/01_Scripts/02_validate_cast.py` must end in `PASSED`. It checks the
   raw deck and names the card and the fix. The two icon messages:
   - *"isn't in the web app yet"* → run step 3.
   - *"there is no assets/inline icons/…"* → the token in the sheet has a typo, or the SVG is missing
     from `assets/inline icons/<type>/`.
3. **Embed icons.** `python3 dextrous/01_Scripts/03_build_svg_sprite.py`. The web app can't load image files, so
   icons are copied into `CastRecruiter.html`. Only the icons the CSV uses are embedded, which is why
   a newly used icon needs this step.
4. **Compile.** `python3 dextrous/01_Scripts/04_generate_card_images.py`. This writes `webapp/CardImages.gs` (where
   each card's art is) and `MonuMentuM DD-MM-YYYY - Processed.json`, the raw deck with names, IDs and
   classes stamped in. A Dextrous export has no names, so they're matched to the CSV **by row position**.
5. **Check the contact sheet.** `python3 dextrous/01_Scripts/05_make_contact_sheet.py`, then open
   `dextrous/contact_sheet.html` and scroll: every name must match the art above it. This is the only
   check that catches the `DEX Cast` tab's row order drifting from `IN Cast`. Every other check
   still passes when that happens.
6. **Check contrast.** `python3 dextrous/01_Scripts/06_check_theme_contrast.py` must pass.

`99_extract_brand_palette.py` isn't part of any update: it's a one-off that re-reads the palette out of the branding PDF.

Icon size: in `CastRecruiter.html`, `--stat-icon-size` sets the prowess, fortitude and ether icons and `--dice-icon-size` the dice. The dice SVGs keep their blank space below for Dextrous; `03_build_svg_sprite.py` crops it off for the web app, so re-run step 3 after replacing a dice SVG.

## Deploy

- **Web app.** `cd webapp && clasp push`, or paste the changed files (`CastRecruiter.html`,
  `main.gs`, `CardImages.gs`) into the Apps Script editor. The `/dev` URL updates at once. To update
  the public URL:
  `clasp deploy -i AKfycbzJ_rRo1MT81RSvWaqHqFvRzJ9utCt0stRyWUT6TguOIscMNviKVxogu8qwfqyxaBbT`.
  **Never run a plain `clasp deploy`**: it creates a new public URL.
- **TTS deck.** Copy `dextrous/MonuMentuM DD-MM-YYYY - Processed.json` into TTS's Saved Objects
  folder, spawn it, and swap it for the old deck in the Cast zone.
- **TTS models** (only if card IDs or classes changed). On the injector token, click
  *Inject IDs to Models*, then save the models bag.
  A card rename doesn't reach the models: each keeps its own name in the bag, which only shows on hover and in health-change chat messages, since spawning matches by ID. Rename them by hand if you want them to match. The injector pairs models with cards **by name**, so rename the models before re-running it, or the renamed ones come back unmatched.
- **TTS scripts.** Re-paste the changed `.lua` onto its object. Never paste
  `Floating_Health_Tracker.lua` on its own. `Model_ID_Injector.lua` carries a copy of it, so change
  both files identically, re-paste the injector and re-run it.

## Save the work

Only code and assets are committed. The cast CSV, the Dextrous deck JSON and `webapp/CardImages.gs` are
gitignored data: keep them in the working copy (TTS and `clasp push` use them) but don't commit them.

```bash
git add -A && git commit -m "What changed" && git push
```
