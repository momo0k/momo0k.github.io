#! /bin/bash
# https://raw.githubusercontent.com/momo0k/momo0k.github.io/dac506f48a0e6d3f712c559485676dddf9099da9/sha256_ed25519.htmx
# find -type f -exec sed -i 's/blanc/noir/g' {} +
NAME=aloha
WEB=may
second=On
PACK=(libreoff fire vlc gimp)
mkdir /var/log/setup 2>/dev/bul || apt update -y 1>> /dev/null 2>>/var/log/setup/warning_apt_update.log && echo -e 'Removing: \n ' ${PACK[@]}  '\n';
for _o in ${PACK[@]}; do
echo "  Completing: for $_o*";
apt autoremove -y $_o* 1>> /var/log/setup/detautoremove.log 2> /var/log/setup/warnings_libreoff.log; done
git config --global user.email "-"
git config --global user.name "-"
# echo $SSH_AUTH_SOCK
# eval "$(ssh-agent -s)"
apt update -y && apt install chromium -y
sed -i '1s/.*/127.0.0.1     $NAME/' /etc/hosts
useradd -m -s /bin/bash $WEB && passwd $WEB
useradd -m -s /bin/bash $second && passwd $second
sudo tee /etc/nftables.conf > /dev/null <<'EOF'
table inet filter {
    chain input {
        type filter hook input priority 0;
        policy drop;

        tcp flags == 0 counter drop
        tcp flags & (syn | fin) == (syn | fin) counter drop
        tcp flags & (syn | rst) == (syn | rst) counter drop
        tcp flags & (fin | psh | urg) == (fin | psh | urg) counter drop

        # loopback
        iif lo counter accept

        # established
        ct state established counter accept

        ip protocol udp limit rate 100/second accept

        ct state invalid counter drop
        log prefix "nft-input-drop: " level info flags all
        counter drop

    }

    chain forward {
        type filter hook forward priority 0;
        policy drop;
    }

    chain output {
        type filter hook output priority 0;
        policy drop;

        # restrictions
        meta skuid 1002 tcp dport 22 counter accept
        meta skuid "berry" udp dport 53 counter accept
        meta skuid "berry" tcp dport 53 counter accept
        meta skuid "berry" tcp dport 443 counter accept
        meta skuid "berry" tcp dport 80 counter drop
        meta skuid "berry" counter log prefix "berry-drop: " level info drop
    }
}
EOF
sed -i "s/berry/$WEB/g" /etc/nftables.conf
nft flush ruleset
nft -f /etc/nftables.conf
echo "$WEB ALL=(root) NOPASSWD: /usr/sbin/nft list ruleset" | sudo tee /etc/sudoers.d/$WEB > /dev/null
sudo chmod 440 /etc/sudoers.d/$WEB
nft list ruleset
# journalctl -k | grep "nft-input-drop"
# nft flush ruleset
# sudo nft -c -f /etc/nftables.conf
