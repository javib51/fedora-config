#!/bin/bash

# VARS
export FLUTTERV='flutter_linux_v1.5.4-hotfix.2-stable.tar.xz'
# Fedora update
sudo dnf update -y
sudo rm -rf /var/cache/PackageKit
sudo systemctl –now mask packagekit-offline-update.service
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
sudo dnf install ~/Downloads/google-chrome-stable_current_x86_64.rpm 
sudo dnf install -y snapd git vim htop
sudo ln -s /var/lib/snapd/snap /snap

# git config
git config --global credential.helper 'cache --timeout=3600'
git config --global user.name "Javier Benitez"
git config --global user.email javier.benitezf51@gmail.com

# Install docker
sudo dnf -y remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf config-manager --set-enabled docker-ce-nightly
sudo dnf -y install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Install snaps
sudo snap install telegram-desktop postman zenkit mailspring overleaf polarr
sudo snap install goland --classic
sudo snap install pycharm-professional --classic
sudo snap install slack --classic
sudo snap install intellij-idea-ultimate --classic
sudo snap install webstorm --classic
sudo snap install skype --classic
sudo snap install go --classic

# Install flutter
mkdir ~/programs
cd ~/programs
wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/$FLUTTERV
tar xf ./$FLUTTERV
rm -rf ./$FLUTTERV
export PATH="$PATH:`pwd`/flutter/bin"
flutter upgrade
flutter precache

# Install dart
sudo dnf -y install git subversion make gcc-c++ python
cd ~/programs
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$PATH:`pwd`/depot_tools
mkdir dart-sdk
cd dart-sdk
fetch dart
cd sdk
sudo mkdir -p /usr/local/dart-out/
./tools/build.py --mode release --arch x64 create_sdk
./tools/build.py --mode release --arch x64 runtime
sudo ln -s -f /usr/local/dart-out/ out
sudo reboot
