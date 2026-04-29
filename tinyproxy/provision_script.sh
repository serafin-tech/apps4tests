#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get -uyq dist-upgrade
apt-get install -yq \
    mc unzip lynx elinks \
    apparmor-utils sysstat htop btop \
    tmux fzf net-tools debsums vim \
    ca-certificates curl \
    tinyproxy

update-alternatives --set editor /usr/bin/vim.basic
echo "SELECTED_EDITOR=\"/usr/bin/vim.basic\"" > /root/.selected_editor

timedatectl set-timezone Europe/Warsaw
service systemd-timesyncd restart
timedatectl status
timedatectl show-timesync

# root user environment
cp -vf /etc/skel/{.profile,.bashrc} /root/

sed -i '/^HISTSIZE/c\HISTSIZE=5000' /root/.bashrc
sed -i '/^HISTFILESIZE/c\HISTFILESIZE=5000' /root/.bashrc
sed -i '/^HISTFILESIZE/a\HISTTIMEFORMAT="%Y-%m-%d %H:%M > "' /root/.bashrc

sed -i '/^#force_color_prompt/c\force_color_prompt=yes' /root/.bashrc
sed -i '/PS1=/s/01;32m/01;31m/' /root/.bashrc

echo -e "\nset -o vi" | tee -a /root/.bashrc

echo -e "\nsource /usr/share/doc/fzf/examples/key-bindings.bash" | tee -a /root/.bashrc

# command's aliases
cat > /root/.bash_aliases <<EOF
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
EOF

# vim
cat > /root/.vimrc <<EOF
syntax on
set tabstop=8
set softtabstop=2
set shiftwidth=2
set noautoindent
set nowrap
set modeline
EOF

cat > /root/.selected_editor <<EOF
SELECTED_EDITOR="/usr/bin/vim.basic"
EOF

# tinyproxy configuration
# Allow connections from any address (required for forwarded port access from host)
sed -i 's/^Allow 127\.0\.0\.1/# Allow 127.0.0.1/' /etc/tinyproxy/tinyproxy.conf
sed -i 's/^Allow ::1/# Allow ::1/' /etc/tinyproxy/tinyproxy.conf
# Log to syslog for easy troubleshooting
sed -i 's|^#\?\s*Syslog On|Syslog On|' /etc/tinyproxy/tinyproxy.conf

systemctl enable tinyproxy
systemctl restart tinyproxy
systemctl status tinyproxy
