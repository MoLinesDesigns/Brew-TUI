# Generates the hero GIF for the README and website — assets/demo.gif
# Usage: vhs scripts/demo.tape
#
# Navigation model (0.9.0/0.9.1+): the side menu is active by default on
# launch. We drive it with Down/Up + Enter (Enter both navigates and closes
# the menu — see scripts/screenshots.tape for the full MENU_VIEWS index map
# and rationale). A short settle Sleep before each Enter avoids a rare race
# where Enter fires before the cursor's last move is committed.

Output assets/demo.gif

Set Shell "zsh"
Set FontSize 16
Set Width 1280
Set Height 720
Set Theme "Dracula"
Set TypingSpeed 70ms
Set PlaybackSpeed 1.0
Set Padding 24

Type "brewtui-bar --lang=en" Enter
Sleep 7s

# ── Dashboard (0) -> Outdated (2) ──
Down@200ms 2
Sleep 300ms
Enter
Sleep 3s

# ── Outdated (2) -> Services (4) ──
Type "m"
Sleep 400ms
Down@200ms 2
Sleep 300ms
Enter
Sleep 2500ms

# ── Services (4) -> Doctor (5) ──
Type "m"
Sleep 400ms
Down@200ms 1
Sleep 300ms
Enter
Sleep 4s

# ── Doctor (5) -> Smart Cleanup (7, Pro) ──
Type "m"
Sleep 400ms
Down@200ms 2
Sleep 300ms
Enter
Sleep 3500ms

# ── Smart Cleanup (7) -> Security Audit (12, Pro) — live/cached OSV scan ──
Type "m"
Sleep 400ms
Down@200ms 5
Sleep 300ms
Enter
Sleep 4s

# ── Security Audit (12) -> back to Dashboard (0) ──
Type "m"
Sleep 400ms
Up@180ms 12
Sleep 300ms
Enter
Sleep 2500ms

Type "q"
Sleep 500ms
