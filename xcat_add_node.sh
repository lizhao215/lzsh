#!/bin/bash
###############################################
#$1 xcatd_ip                                  #
#$2 netboot   (ipmi/pxe) 默认pxe              #
#$3 os        (centos7.6/...) 默认centos7     #
###############################################

if [ ! -n "$1" ] ;then
    echo "you have not input a agrs!"
    exit 1
else
    echo "the xcatd_ip args you input is $1"
    xcatd_ip=$1
fi
if [ ! -n "$2" ] ;then
    echo "netboot default pxe!"
    netboot="pxe"
else
    echo "the netboot args you input is $2"
    netboot=$2
if [ ! -n "$3" ] ;then
    echo "os default centos7!"
    os="centos7"
else
    echo "the os args you input is $3"
    os=$3

source /etc/profile.d/xcat.sh


sed -n '3,1000p' /etc/hosts | while read LINE
do 
    # 判断空行
    if [ ! -n "$LINE" ]; then 
       echo "this line IS NULL,skip to continue"
       continue
    else
       echo $LINE
    fi
    ######## ip, hostname
    ip=`echo $LINE | awk '{print $1}'`
    hostname=`echo $LINE | awk '{print $2}'`

    ######## mac, mac_name
    ip_str=`ssh $hostname ifconfig | grep $ip -A 2 -B 1`
    mac_name=${ip_str%%:*}
    mac=`ssh $hostname ifconfig | grep $ip -A 2 -B 1 | grep ether | awk '{print $2}'`
    echo $mac_name $mac
    ######## add
    echo "start add $hostname"
    nodeadd $hostname \
        groups=compute,all \
        mac.interface=$mac_name \
        mac.mac=$mac \
        hosts.ip=$ip \
        noderes.netboot=$netboot \
        noderes.xcatmaster=$xcatd_ip \
        noderes.installnic=$mac_name \
        noderes.primarynic=$mac_name \
        noderes.nfsserver=$xcatd_ip \
        nodetype.os=$os \
        nodetype.arch=x86_64 \
        nodetype.profile=compute \
        nodetype.nodetype=osi  
done
