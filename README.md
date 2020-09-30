# setup-macos
A small project with a shell script to install my basic MacOS environment (mostly to share it with other people)

## How To Install

Simply running
```
mkdir bootstrap
cd bootstrap
brew install wget
wget https://raw.githubusercontent.com/Aduril/setup-macos/master/bootstrap.sh
chmod 755 ./bootstrap.sh
./bootstrap.sh
cd ..
rm -rf bootstrap
```
