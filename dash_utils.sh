#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be ran as root or sudo" 1>&2
   exit 1
fi

echo "Creating shell script"
rm -rf /usr/bin/dashd-cli /usr/bin/dashd-update /usr/bin/dash-rm


cat >/usr/bin/dashd-cli <<'EOL'
#!/usr/bin/env bash
docker exec -it dashd-node /bin/bash -c "dash-cli $*"
EOL

cat >/usr/bin/dashd-update <<'EOL'
#!/usr/bin/env bash
set -e
if [[ $EUID -ne 0 ]]; then
   echo "This script must be ran as root or sudo" 1>&2
   exit 1
fi
VERSION="${1:-latest}"
echo "Stopping dashd"
docker exec -it dashd-node /bin/bash -c "dash-cli stop"
echo "Waiting dashd gracefull shutdown...30-60secs"
sleep 10sleep
echo "Updating dashd to $VERSION version..."
docker pull bitsler/docker-dashcoind:$VERSION
echo "Removing old dashd installation"
docker rm dashd-node
echo "Running new dashd-node container"
docker run -v dashd-data:/dashcoin --name=dashd-node -d \
      -p 9999:9999 \
      -p 9998:9998 \
      -v $HOME/.dashdocker/dash.conf:/dashcoin/.dashcore/dash.conf \
      bitsler/docker-dashcoind:$VERSION

echo "Dashcoind successfully updated to $VERSION and started"
echo ""
EOL

cat >/usr/bin/dash-rm <<'EOL'
#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be ran as root or sudo" 1>&2
   exit 1
fi
echo "WARNING! This will delete ALL dashd-docker installation and files"
echo "Make sure your wallet.dat is safely backed up, there is no way to recover it!"
function uninstall() {
  sudo docker stop dashd-node
  sudo docker rm dashd-node
  sudo rm -rf ~/docker/volumes/dashd-data ~/.dashdocker /usr/bin/dashd-cli
  sudo docker volume rm dashd-data
  echo "Successfully removed"
  sudo rm -- "$0"
}
read -p "Continue (Y)?" choice
case "$choice" in
  y|Y ) uninstall;;
  * ) exit;;
esac
EOL

chmod +x /usr/bin/dashd-cli
chmod +x /usr/bin/dash-rm
chmod +x /usr/bin/dashd-update

echo "Done!"