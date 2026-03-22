#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

debconf-set-selections <<EOT
dbconfig-common	dbconfig-common/mysql/admin-pass password password
dbconfig-common	dbconfig-common/mysql/admin-user string	root
dbconfig-common	dbconfig-common/mysql/app-pass	password password
EOT

apt-get -uyq dist-upgrade
apt-get install -yq \
    mc unzip lynx elinks \
    apparmor-utils sysstat htop btop \
    tmux fzf net-tools debsums vim \
    ca-certificates curl python3 python3-pip python3-venv

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
