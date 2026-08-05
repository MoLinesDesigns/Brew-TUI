# VHS tape — captures every BrewTUI-Bar view as PNG into assets/screenshots/
# Usage: vhs scripts/screenshots.tape
#
# Navigation model (0.9.0/0.9.1+): the side menu is active by default on
# launch — arrows operate it, numbers no longer jump between views. We relaunch
# a fresh session per view and drive the side menu with Down N + Enter, where N
# is the view's index in MENU_VIEWS (src/stores/navigation-store.ts):
#   0 dashboard, 1 installed, 2 outdated, 3 package-info, 4 services, 5 doctor,
#   6 profiles, 7 smart-cleanup, 8 history, 9 rollback, 10 brewfile, 11 sync,
#   12 security-audit, 13 compliance, 14 account
# Enter both navigates AND closes the menu (selectMenuItem sets menuMode:
# false), so screenshots land with the header showing the plain "M: menu"
# hint, matching the pre-0.9.0 look. For dashboard (index 0, already current
# view at cold start) a bare Enter just closes the menu without navigating.
#
# Pro views (Smart Cleanup, Security Audit, Brewfile, Sync) require a Pro
# license active in ~/.brewtui-bar/license.json — see assets/README.md.

Output assets/screenshots/_dummy.gif

Set Shell "zsh"
Set FontSize 14
Set Width 1440
Set Height 900
Set Theme "Dracula"
Set TypingSpeed 60ms
Set Padding 24

# ── Dashboard ──
Type "brewtui-bar --lang=en" Enter
Sleep 8s
Enter
Sleep 1s
Screenshot assets/screenshots/dashboard.png
Type "q"
Sleep 1s

# ── Outdated (index 2) ──
Type "brewtui-bar --lang=en" Enter
Sleep 8s
Down@150ms 2
Enter
Sleep 4s
Screenshot assets/screenshots/outdated.png
Type "q"
Sleep 1s

# ── Services (index 4) ──
Type "brewtui-bar --lang=en" Enter
Sleep 8s
Down@150ms 4
Enter
Sleep 4s
Screenshot assets/screenshots/services.png
Type "q"
Sleep 1s

# ── Doctor (index 5) ──
Type "brewtui-bar --lang=en" Enter
Sleep 8s
Down@150ms 5
Enter
Sleep 10s
Screenshot assets/screenshots/doctor.png
Type "q"
Sleep 1s

# ── Smart Cleanup (Pro, index 7) ──
Type "brewtui-bar --lang=en" Enter
Sleep 8s
Down@150ms 7
Enter
Sleep 6s
Screenshot assets/screenshots/smart-cleanup.png
Type "q"
Sleep 1s

# ── Declarative Brewfile (Pro, index 10) ──
Type "brewtui-bar --lang=en" Enter
Sleep 8s
Down@150ms 10
Enter
Sleep 4s
Screenshot assets/screenshots/brewfile.png
Type "q"
Sleep 1s

# ── Cross-machine Sync (Pro, index 11) ──
Type "brewtui-bar --lang=en" Enter
Sleep 8s
Down@150ms 11
Enter
Sleep 4s
Screenshot assets/screenshots/sync.png
Type "q"
Sleep 1s

# ── Security Audit (Pro, index 12) — hits the on-disk OSV cache ──
Type "brewtui-bar --lang=en" Enter
Sleep 8s
Down@150ms 12
Enter
Sleep 6s
Screenshot assets/screenshots/security-audit.png
Type "q"
Sleep 500ms
