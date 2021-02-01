#!/bin/sh

scp alpine-clash.sh clash:~/
scp clash-linux-amd64-v1.0.0 clash:/usr/sbin/clash
scp ~/.config/clash/Country.mmdb clash:~/.config/clash/
scp ~/.config/clash/config.yaml clash:~/.config/clash/
scp -r ~/.config/clash/yacd-gh-pages clash:~/.config/clash/

exit 0
