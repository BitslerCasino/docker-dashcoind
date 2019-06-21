# docker-dashcoind
Docker Image for Dash

### Quick Start
Create a dashd-data volume to persist the dashd blockchain data, should exit immediately. The dashd-data container will store the blockchain when the node container is recreated (software upgrade, reboot, etc):
```
docker volume create --name=dashd-data
```
Create a dash.conf file and put your configurations
```
mkdir -p .dashdocker
nano /home/$USER/.dashdocker/dash.conf
```

Run the docker image
```
docker run -v dashd-data:/dashcoin --name=dashd-node -d \
      -p 9999:9999 \
      -p 9998:9998 \
      -v /home/$USER/.dashdocker/dash.conf:/dashcoin/.dashcore/dash.conf \
      unibtc/docker-dashcoind
```

Check Logs
```
docker logs -f dashd-node
 ```

Auto Installation
```
sudo bash -c "$(curl -L https://github.com/BitslerCasino/docker-dashcoind/releases/download/v0.14.0.1/dash_install.sh)"
```
Install Utilities
```
sudo bash -c "$(curl -L https://github.com/BitslerCasino/docker-dashcoind/releases/download/v0.14.0.1/dash_utils.sh)"
```