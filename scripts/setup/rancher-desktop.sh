if [ $(which rancher-desktop) == ""];
then
  # add user to kvm group
  usermod -a -G kvm $username

  # Allow Traefik (default ingress ctrl) to listen to port 80
  sysctl -w net.ipv4.ip_unprivileged_port_start=80

  curl -s https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/Release.key | gpg --dearmor | dd status=none of=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg
  echo 'deb [signed-by=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg] https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/ ./' | dd status=none of=/etc/apt/sources.list.d/isv-rancher-stable.list

fi