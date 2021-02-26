#!/bin/bash

#------------------------------------------------------------------#
#							           #
# Resolve the domain name given and adds an iptables/ip6tables     #
# rule in order to allow traffic for this. It's useful when you    #
# have other rules which which blocks other traffic (such as       #
# http) and you only want to allow access to specific domain       #
# name. This script requires system admin privileges               #
#							           #
#------------------------------------------------------------------#

ok_msge="[ \e[32m OK  \e[39m]"
info_msge="[ \e[33mINFO \e[39m]"
err_msge="[ \e[31mERROR \e[39m]"
domain=${1:?"No domain name given"}
install_iptables_err_mess="This script needs iptables program, but is not installed\nInstalled with: apt-get install iptables and rerun script"

function print_help () {
  echo -e '\nDescription: Resolve the domain name given and adds an iptables/ip6tables rule in order to allow traffic for this.\n'
  echo -e "Usage: \e[1m${0}\e[0m \e[4mdomainname\e[0m\n"
}

function allow_ip_on_ipv4 () {
  sudo iptables -I INPUT 1 -s "$resolved_domain" -j ACCEPT
  sudo iptables -I OUTPUT 1 -d "$resolved_domain" -j ACCEPT
}

function allow_ip_on_ipv6 () {
  sudo ip6tables -I INPUT 1 -s "$resolved_domain" -j ACCEPT
  sudo ip6tables -I OUTPUT 1 -d "$resolved_domain" -j ACCEPT
}

[[ $1 =~ -h|--help ]] && print_help && exit 0

# check if iptables is installed
which_iptables="$(which iptables)"

[[ $? -ne 0 ]]  && echo -e "$install_iptables_err_mess" && exit 1 

echo -e "$info_msge Resolving domain name ..."

dns_response="$(systemd-resolve $1 2> /dev/null)"

[[ $? -ne 0 ]] && echo -e "$err_msge Can't resolve domain name given" && exit 1

resolved_domain="$(echo $dns_response | sed -n '1p' | awk '{print $2}')"

if echo "$resolved_domain" | grep -q -E '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
  allow_ip_on_ipv4
else
  allow_ip_on_ipv6
fi

echo -e "$ok_msge Iptables rules added with exit"

exit 0
