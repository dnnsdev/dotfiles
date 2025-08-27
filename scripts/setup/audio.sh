#!/bin/bash

# Backup the original file
# cp /etc/pulse/daemon.conf /etc/pulse/daemon.conf.bak

# Uncomment and change resample-method to speex-float-5
#sed -i 's/^;*\\s*resample-method.*/resample-method = speex-float-5/' /etc/pulse/daemon.conf

# Restart PulseAudio
#pulseaudio -k

echo "Sound improvements applied. Original config backed up as /etc/pulse/daemon.conf.bak"