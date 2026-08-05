# Marketing assets

Assets referenced by the project README and used across launch channels.

## Files

| File | Used in | How to (re)generate |
|---|---|---|
| `demo.gif` / `demo.mp4` / `demo.webm` | README hero, website, Reddit, Twitter, PH | `vhs scripts/demo.tape`, then `ffmpeg` to MP4/WebM (see website deploy notes) |
| `screenshots/dashboard.png` | README, website | `vhs scripts/screenshots.tape` |
| `screenshots/outdated.png` | README, website | `vhs scripts/screenshots.tape` |
| `screenshots/services.png` | README, website | `vhs scripts/screenshots.tape` |
| `screenshots/doctor.png` | README, website | `vhs scripts/screenshots.tape` |
| `screenshots/smart-cleanup.png` | README, website (as `brewtui-bar-cleanup`) | `vhs scripts/screenshots.tape` |
| `screenshots/brewfile.png` | website (as `brewtui-bar-brewfile`) | `vhs scripts/screenshots.tape` |
| `screenshots/sync.png` | website (as `brewtui-bar-sync`) | `vhs scripts/screenshots.tape` |
| `screenshots/security-audit.png` | README, website | `vhs scripts/screenshots.tape` |
| `screenshots/brewbar.png` | TODO — README BrewTUI-Bar section | Manual: `Cmd+Shift+4` + `Space` over the popover |

The website (`/Volumes/SSD/Projects/Website/public/brewtui-bar/assets/`) keeps its own
copies, renamed `brewtui-bar-{view}.png/.webp`, pngquant-compressed and with a WebP
sibling (`cwebp -q 82`). Regenerate there by re-running the steps below and copying
+ renaming into that repo — the two repos are not symlinked.

## Capture rules

- **Terminal**: 1440×900 (screenshots) or 1280×720 (GIF), font size 14-16, `dracula` theme.
- **Navigation (0.9.0+)**: the side menu is active by default on launch — numbers no longer jump
  between views. Drive it with `Down`/`Up` + `Enter` against the `MENU_VIEWS` index order
  (`src/stores/navigation-store.ts`); `Enter` both navigates and closes the menu. See the
  comment header in `scripts/screenshots.tape` for the full index map. When chaining multiple
  hops in one session (as `demo.tape` does), leave a short settle `Sleep` (~300ms) before each
  `Enter` — firing it immediately after the last `Down`/`Up` can occasionally leave the menu
  open instead of closing it.
- **Compression**: `pngquant --quality=80-95 *.png --ext .png --force` before commit. Target <100 KB each.
- **GIF size**: stay under 5 MB. If over, run `gifsicle -O3 --lossy=80 -o demo.gif demo.gif` (plain `-O3` is usually enough).
- **Pro views** (Smart Cleanup, Security Audit, Brewfile, Sync) need a Pro license active in
  `~/.brewtui-bar/license.json`. Test PRO key is `admin@molinesdesigns.com` (built-in). Security
  Audit results are cached to `~/.brewtui-bar/cve-cache.json` — a second capture will show
  "Showing cached results" and load near-instantly instead of re-running the live OSV scan.

## Tooling

```bash
brew install vhs pngquant ffmpeg gifsicle webp
```

## Notes on `brewbar.png`

The BrewTUI-Bar popover screenshot has to be captured manually because `screencapture` requires Screen Recording permission. To produce it:

1. Open BrewTUI-Bar in your menu bar (it's running if you're a Pro user).
2. Click its menu bar icon to open the popover.
3. `Cmd+Shift+4`, then press `Space`, then click the popover window.
4. Save to `assets/screenshots/brewbar.png`.
5. Run `pngquant --quality=80-95 assets/screenshots/brewbar.png --ext .png --force`.
6. Re-add the BrewTUI-Bar row to the README screenshots grid.
