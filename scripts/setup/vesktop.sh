if [ $(which vesktop) == "" ];
then

  wget https://vencord.dev/download/vesktop/amd64/deb -O vesktop.deb

  dpkg -i vesktop.deb

fi