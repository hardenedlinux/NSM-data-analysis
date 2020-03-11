#!/usr/bin/env bash


get_ip(){
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    [ ! -z ${IP} ] && echo ${IP} || echo
}
echo -e "Your Server IP        : \033[41;37m $(get_ip) \033[0m"
