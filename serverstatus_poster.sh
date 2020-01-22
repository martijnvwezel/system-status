#!/bin/bash
# Made by:  martijnvwezel@muino.nl (2018) Muino

# nproc | awk '{print "CPU cores:" $1 }' # shows the number of cpu cores
# cpucores = nproc
# echo cpucores
APPKEY=[REMOVED]

DATE=`date`
CPU_TYPE=$(cat /proc/cpuinfo | grep "model name" | head -1 | awk -F':' '{print $2}')
HOSTNAME=`hostname -f`
CPU_LOAD=`cat /tmp/cpu.txt`
#MEM=`free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)", ($2-$4),$2,($2-$4)*100/$2 }'`
MEM=`free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)", ($3),$2,($3)*100/$2 }'`
DISK=`df -hTm '/' | awk '$NF=="/"{printf "%0.2f/%0.2fGB (%s)", $4/1000,$3/1000,$6}'`
DISK2=`df -hTm '/srv/owncloud' | awk '$NF=="/srv/owncloud"{printf "%0.2f/%0.2fGB (%s)", $4/1000,$3/1000,$6}'`
UPTIME=`uptime -p`

IP_ETH0=`ip a | grep "global eth0" |  cut -d 't' -f 2 | cut -d ' ' -f 2 | cut -d '/' -f 1`
# IP_WLAN0=`ip a | grep "global wlan0" |  cut -d 't' -f 2 | cut -d ' ' -f 2 | cut -d '/' -f 1`
# IP_TUN0=`ip a | grep "global tun0" |  cut -d 't' -f 2 | cut -d ' ' -f 2 | cut -d '/' -f 1`

MAC_ETH0=`ip a | grep -m2 " link/ether" | cut -d 'r' -f 2 | cut -d ' ' -f 2 | head -1`
# MAC_WLAN0`ip a | grep -m2 " link/ether" | cut -d 'r' -f 2 | cut -d ' ' -f 2 | tail -1`
 STATUS_ETH0=`cat /sys/class/net/eth0/operstate`
# STATUS_WLAN0=`cat /sys/class/net/wlan0/operstate`
# STATUS_OVPN=`sudo service openvpn status |  grep active`

# STATUS_[REMOVED]=`sudo systemctl status [REMOVED] |  grep active`
# STATUS_[REMOVED]=`sudo systemctl status [REMOVED] |  grep active`
# VERSION_[REMOVED]=`/opt/[REMOVED]_service -V`
# VERSION_[REMOVED]=`/opt/[REMOVED]_connector -V`
VERSION_SYSTEM_STATUS_POSTER=`echo "V1.1a"`



#CPU_LOAD="1000%"
#MEM="10000/1GB (1000%)"
#DISK="10000/1GB (1000%)"
#DISK2="10000/1GB (1000%)"



[ ! -z "$DATE" ] || DATE=" "
[ ! -z "$CPU_TYPE" ] || CPU_TYPE=" "
[ ! -z "$HOSTNAME" ] || HOSTNAME=" "
[ ! -z "$CPU_LOAD" ] || CPU_LOAD=" "
[ ! -z "$MEM" ] || MEM=" "
[ ! -z "$DISK" ] || DISK=" "
[ ! -z "$DISK2" ] || DISK2=" "
[ ! -z "$UPTIME" ] || UPTIME=" "
[ ! -z "$IP_ETH0" ] || IP_ETH0=" "
[ ! -z "$MAC_ETH0" ] || MAC_ETH0=" "
[ ! -z "$STATUS_ETH0" ] || STATUS_ETH0=" "
[ ! -z "$VERSION_SYSTEM_STATUS_POSTER" ] || VERSION_SYSTEM_STATUS_POSTER=" "

PAYLOAD=`echo "\
{\"status\":{\"linux_time\":\"$DATE\",\
\"cpu_variant\":\"$CPU_TYPE\",\
\"hostname\":\"$HOSTNAME\",\
\"cpu_load\":\"$CPU_LOAD\",\
\"mem\":\"$MEM\",\
\"disk\":\"$DISK\",\
\"disk2\":\"$DISK2\",\
\"Uptime\":\"$UPTIME\",\
\"wired_ip\":\"$IP_ETH0\",\
\"mac_eth0_ip\":\"$MAC_ETH0\",\
\"wired_status\":\"$STATUS_ETH0\",\
\"version_system_poster\":\"$VERSION_SYSTEM_STATUS_POSTER\",\
\"uniquekey\": \"$APPKEY\",\
}}"`

echo "$PAYLOAD"


curl -d "$PAYLOAD" -H "Content-Type: application/json" https://muino.nl/[removed]
