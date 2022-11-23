#!/bin/bash

echo "Updating DNF repository"
sudo dnf upgrade -y

echo "Install neofetch, and screen"
sudo dnf install neofetch screen-y

echo "Install Docker"
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo systemctl enable docker
sudo systemctl start docker

echo "Install glances and sysbench"
sudo dnf install glances sysbench -y

echo "Install Skaffold (v2.0.0)"
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/v2.0.0/skaffold-linux-amd64 && \
sudo install skaffold /usr/local/bin/

echo "Install gsutil"
sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el8-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
sudo dnf install libxcrypt-compat.x86_64 google-cloud-cli -y