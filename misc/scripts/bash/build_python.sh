#/bin/sh
VERSION=$1

# Install dependencies
sudo apt update && sudo apt upgrade
sudo apt install build-essential libssl-dev zlib1g-dev libncurses5-dev libncursesw5-dev libreadline-dev libsqlite3-dev  libgdbm-dev libdb5.3-dev libbz2-dev libexpat1-dev liblzma-dev libffi-dev

# Build and install python
wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz
tar xf Python-$VERSION.tar.xz
cd Python-$VERSION
./configure --enable-optimizations
make -j $(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')
sudo make altinstall