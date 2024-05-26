#!/usr/bin/env zsh
############################
# This script creates symlinks from the home directory to any desired dotfiles in $HOME/dotfiles
# And also installs MacOS Software
# And also installs Homebrew Packages and Casks (Apps)
# And also sets up VS Code
############################

# dotfiles directory
dotfiledir="${HOME}/.dotfiles"

echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Installing Homebrew and Homebrew Packages..."
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Install Homebrew Packages
brew bundle --file="${dotfiledir}/Brewfile"

# list of files/folders to symlink in ${homedir}
files=(.zshrc .zprofile .profile .gitconfig)

# change to the dotfiles directory
echo "Changing to the ${dotfiledir} directory"
cd "${dotfiledir}" || exit

# create symlinks (will overwrite old dotfiles)
for file in "${files[@]}"; do
    echo "Creating symlink to $file in home directory."
    ln -sf "${dotfiledir}/.${file}" "${HOME}/.${file}"
done

echo "Changing zsh theme..."
ln -sf "${dotfiledir}/shades-of-purple.zsh-theme" "${HOME}/.oh-my-zsh/themes/shades-of-purple.zsh-theme"

echo "Installing Hack font..."
unzip Hack.zip -d Hack
# Copy the font files to the fonts directory
cp Hack/*.ttf ~/Library/Fonts/
# Clean up the extracted files
rm -rf Hack

echo "Applying iterm theme..."
open "${dotfiledir}/shades-of-purple.itermcolors"
ln -sf "${dotfiledir}/iterm-profiles.json" "${HOME}/Library/Application\ Support/iTerm2/DynamicProfiles/iterm-profiles.json"

# Specify the preferences directory
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "~/.dotfiles"

# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

echo "Installing Xcode..."
xcode-select --install

echo "Complete the installation of Xcode Command Line Tools before proceeding."
echo "Press enter to continue..."
read

echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

echo "Applying VSCode settings..."
ln -sf "${dotfiledir}/vscode-settings.json" "${HOME}/Library/Application Support/Code/User/settings.json"

echo "Applying macOS system settings..."
${dotfiledir}/macos.sh
