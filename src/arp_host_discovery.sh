#!/bin/bash

####################################################################################
#
# Makes a host discovery sending ARP packet using the network interface IP address 
# and network mask to generate the list of target host addresses network. After 
# this, send and ICMP ECHO Request to see if each discovered supports this 
# service or inform the problem ocurred
#
###################################################################################

ok_msge="[ \e[32m OK  \e[39m]"
info_msge="[ \e[33mINFO \e[39m]"
err_msge="[ \e[31mERROR \e[39m]"
problem_found_msge="Problem found on host"
show_uphosts=all

function print_help () {
  echo -e '\nDescription: makes a host discovery sending ARP packet using the network interface IP address and network mask to generate the list of target host addresses network. After this, send and ICMP ECHO Request to see if each discovered supports this service or inform the problem ocurred. If -u and -f are set in conjunction, just the last option given will be taken. It requires system admin privileges\n'
  echo -e "Usage: \e[1m${0}\e[0m [ -u|--show-up ] [ -f|--show-failed ]\n"
  echo 'Options:' 
  echo -e '  -u|--show-up print only host which are up'
  echo -e '  -f|--show-failed print only host which have failed when sending ICMP Echo Request'
  exit 0
}

function print_host_is_up () {
  local host="$1"

  if [[ "$show_uphosts" == all ]]; then
    echo -e "$info_msge Host $host is up"
  else
    [[ "$show_uphosts" == yes ]] && echo "$host"
  fi
}

function print_host_ping_failed () {
    
  if [[ "$show_uphosts" != yes ]] ; then
    ping_error="$(echo "$ping_res" | grep -m 1 icmp_seq)"
    [[ $? -eq 1 ]] && echo -e "$info_msge $problem_found_msge ${host}: can't determine the reason of the problem" && return
    ping_error="$(echo "$ping_error" | sed 's/.*icmp_seq=[0-9]//g')"
    echo -e "$info_msge $problem_found_msge ${ip}:${ping_error}"
  fi
}

function test_host_is_up () {
  local host ping_res ping_error
  host="$1"

  ping_res="$(ping -c 3 $host)"

  if [[ $? -eq 0 ]]; then
    print_host_is_up "$host"
  else
    print_host_ping_failed "$host"
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -u|--show-up) show_uphosts=yes ;;
    -f|--show-ping-failed) show_uphosts=no ;;
    *) print_help ;;
  esac 
  shift
done

# check if arp-scan is installed
which arp-scan > /dev/null
[[ $? -ne 0 ]] && echo -e "$err_msge arp-scan utility is not installed" && exit 1

echo -e "$ok_msge Starting scaning using ARP..."

arp_scan_result="$(sudo arp-scan --localnet | gawk '/^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/ {print $1}')"

while read ip; do
  test_host_is_up "$ip"
done < <(echo -e "$arp_scan_result")

exit 0
