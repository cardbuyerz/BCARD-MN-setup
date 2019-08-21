#!/bin/bash

 
#Delay script execution for N seconds
function delay { echo -e "${GREEN}Sleep for $1 seconds...${NC}"; sleep "$1"; }

#Stop daemon if it's already running
function stop_daemon {
    if pgrep -x 'CARDbuyersd' > /dev/null; then
        echo -e "${YELLOW}Attempting to stop CARDbuyersd${NC}"
        CARDbuyers-cli stop
        delay 30
        if pgrep -x 'axe' > /dev/null; then
            echo -e "${RED}CARDbuyersd daemon is still running!${NC} \a"
            echo -e "${RED}Attempting to kill...${NC}"
            pkill CARDbuyersd
            delay 30
            if pgrep -x 'CARDbuyersd' > /dev/null; then
                echo -e "${RED}Can't stop axed! Reboot and try again...${NC} \a"
                exit 2
            fi
        fi
    fi
}

stop_daemon
echo -e "Removing outdated binaries
This saves the CARDbuyers.conf file intact so genkey should not change"
delay 10

#Remove old binaries
sudo rm ~/BCARD-MN-setup/CARD*
sudo rm /usr/bin/CARD*
sudo rm ~/.CARDbuyers/debug*
sudo rm ~/.CARDbuyers/mncache*

echo -e "Downloading and installing new CARDbuyers Binaries"
#Download new Binaries
 cd ~
wget https://github.com/CARDbuyers/BCARD/releases/download/2.2.0/CARDbuyersd.tar.gz
tar -zxvf CARDbuyersd.tar.gz -C ~/BCARD-MN-setup
rm -rf CARDbuyersd.tar.gz
 
 # Deploy binaries to /usr/bin
 sudo cp ~/BCARD-MN-setup/CARD* /usr/bin/
 sudo chmod 755 -R ~/BCARD-MN-setup
 sudo chmod 755 /usr/bin/CARD*
 
 echo -e "Starting CARDbuyers 2.2.0"
    CARDbuyersd -daemon
    #CARDbuyersd -reindex -daemon
echo -ne '[##                 ] (15%)\r'
sleep 6
echo -ne '[######             ] (30%)\r'
sleep 9
echo -ne '[########           ] (45%)\r'
sleep 6
echo -ne '[############       ] (67%)\r'
sleep 9
echo -ne '[################   ] (72%)\r'
sleep 10
echo -ne '[###################] (100%)\r'
echo -ne '\n'


echo -e "Update Complete !!
You may have to reactivate in wallet. Let sync complete and check local wallet!!
"
delay 30
# Run cardmon.sh
cardmon.sh
