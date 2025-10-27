#!/bin/bash

# this needs to be run as normal user.

mkdir -p /home/dennis/.bin

# Create the symlink
ln -s /home/dennis/scripts/tools/translate.sh /home/dennis/.bin/translate

# Make sure ~/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.bin:"* ]]; then
    echo 'export PATH="$HOME/.bin:$PATH"' >> ~/.bashrc
    echo "Added ~/bin to PATH in ~/.bashrc"
    echo "Run 'source ~/.bashrc' or restart your terminal"
fi