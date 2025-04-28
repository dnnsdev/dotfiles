if [ $(which dotnet) == "" ];
then

  wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

  dpkg -i packages-microsoft-prod.deb

fi