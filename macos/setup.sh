#!/usr/bin/env bash

set -o errexit -o pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ask for the administrator password upfront.
sudo -v

sudo cp "$script_dir/Custom.keylayout" "/Library/Keyboard Layouts"

sudo cp "$script_dir/login.sh" /var/root
sudo chmod +x /var/root/login.sh
sudo defaults write com.apple.loginwindow LoginHook /var/root/login.sh

sudo cp "$script_dir/logout.sh" /var/root
sudo chmod +x /var/root/logout.sh
sudo defaults write com.apple.loginwindow LogoutHook /var/root/logout.sh

# Disable Power Nap.
sudo pmset -a powernap 0

# Hibernate after sleeping for a bit.
sudo pmset -a standby 1 standbydelay 900 hibernatemode 3
sudo pmset -a destroyfvkeyonstandby 1

# Wake up only when power button is pressed.
sudo pmset -a acwake 0 lidwake 0

# Ask for password after screensaver appears.
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Disable local Time Machine backups.
sudo tmutil disablelocal

# Don't reopen windows when logging back in.
defaults write com.apple.loginwindow TALLogoutSavesState -bool false

defaults write -g AppleInterfaceStyle -string "Dark"
defaults write -g AppleLocale -string "en_IE"
defaults write -g AppleMeasurementUnits -string "Centimeters"
defaults write -g AppleMetricUnits -bool true

defaults write -g AppleShowScrollBars -string WhenScrolling

defaults write com.apple.universalaccess reduceTransparency -bool true

# Make key repeating work.
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 20
defaults write -g KeyRepeat -int 3

# Disable smart quotes and dashes as they’re annoying when typing code.
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Enable tap to click for this user and for the login screen.
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.mouse.tapBehavior -int 1

defaults -currentHost write -g com.apple.trackpad.forceClick -int 0
defaults write -g com.apple.trackpad.forceClick -int 0

defaults write -g com.apple.trackpad.scaling -float 1.5

# Trackpad preferences.
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 0

# Disable Touch Bar support in all apps except System Preferences.
defaults write -g NSFunctionBarAPIEnabled -bool NO
defaults write com.apple.systempreferences NSFunctionBarAPIEnabled -bool YES
defaults write com.apple.iTunes NSFunctionBarAPIEnabled -bool YES

# Clear the default Touch Bar items and put the relevant things in the
# expanded area.
defaults write com.apple.controlstrip MiniCustomized -array
defaults write com.apple.controlstrip FullCustomized -array \
  "NSTouchBarItemIdentifierFlexibleSpace" \
  "com.apple.system.group.keyboard-brightness" \
  "com.apple.system.group.brightness" \
  "com.apple.system.group.volume"

# Enable full keyboard access for all controls.
defaults write -g AppleKeyboardUIMode -int 3

# Disable auto-correct.
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Enable subpixel font rendering on non-Apple LCDs.
defaults write -g AppleFontSmoothing -int 2

# Finder preferences.
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

defaults write com.apple.sidebarlists ShowEjectables -bool false

# Avoid creating .DS_Store files on network volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Automatically open a new Finder window when a volume is mounted.
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Disable shadow in screenshots.
defaults write com.apple.screencapture disable-shadow -bool true

# Show remaining battery time; hide percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Disable Dashboard.
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space.
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use.
defaults write com.apple.dock mru-spaces -bool false

# Dock preferences.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock tilesize -int 48

# Expand save/print panels by default.
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
defaults write -g PMPrintingExpandedStateForPrint -bool true

# Airplay preferences.
defaults write com.apple.airplay showInMenuBarIfPresent -bool false

# Clock preferences.
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm"

# Sound preferences.
defaults write com.apple.systemsound com.apple.sound.beep.volume -float 0.0
defaults write -g com.apple.sound.uiaudio.enabled -int 0
defaults write -g com.apple.sound.beep.volume -int 0

# Disable chime when plugging in power cable.
defaults write com.apple.PowerChime ChimeOnAllHardware -bool false
killall "PowerChime"

# Safari preferences.
defaults write com.apple.Safari HistoryAgeInDaysLimit -int 1
defaults write com.apple.Safari HomePage -string "about:blank"
defaults write com.apple.Safari NewTabBehavior -int 1
defaults write com.apple.Safari NewWindowBehavior -int 1
defaults write com.apple.Safari OpenPrivateWindowWhenNotRestoringSessionAtLaunch -bool true
defaults write com.apple.Safari PreloadTopHit -bool false
defaults write com.apple.Safari SearchProviderIdentifier "com.duckduckgo"
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Kill affected apps.
killall "Dock" "Finder" "SystemUIServer" > /dev/null 2>&1
