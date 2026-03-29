#! /bin/bash
PACK=(libreoff fire vlc samba)
mkdir /var/log/setup 2>/dev/bul || apt update -y 1>> /dev/null 2>>/var/log/setup/warning_apt_update.log && echo -e 'Removing: \n ' ${PACK[@]}  '\n';
for _o in ${PACK[@]}; do
echo "  Completing: for $_o*";
apt autoremove -y $_o* 1>> /var/log/setup/detautoremove.log 2> /var/log/setup/warnings_libreoff.log; done
