-- sound improvements

sudo nano /etc/pulse/daemon.conf

remove semicolon in front of 'resample-method'

change speex-float-1 to speex-float-5

use 'pulseaudio -k' to kill daemon
