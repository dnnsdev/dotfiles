if [ $(which brew) == "" ];
then

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

fi

# k9s for kubernetes management
brew install derailed/k9s/k9s