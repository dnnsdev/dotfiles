if [ $(which thorium-browser) == "" ];
then

  wget -O ./thorium-browser.deb "$(curl -s https://api.github.com/repos/Alex313031/Thorium/releases/latest | grep browser_download_url | grep .deb | cut -d '"' -f 4)"

  nala install ./thorium-browser.deb -y

fi