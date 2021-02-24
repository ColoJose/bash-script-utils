#!/bin/bash

##################################################
#
# Takes a file and returns all lines which matches 
# any of configured network interfaces if no 
# options are given
#
##################################################

select_mode=
selected_iface=
err_msge="[ \e[31mERROR \e[39m]"
ifaces=$(ip link ls | grep -E '^[0-9].*' | awk --field-separator=':' '{ gsub(/ /,""); print $2}')
allow_not_config_iface=

function print_help () {
  echo -e '\nDescription: Takes a file and returns all lines which matches configured netowrk interfaces. If -i and -s are used in conjunction, the last specified will be taken as option\n'
  echo -e "Usage: \e[1m${0}\e[0m [ -i|--interactive ] [ [ -nci|--not-config-iface ] -s|--select \e[4miface\e[0m ] \e[4mfile\e[0m\n"
  echo 'Options:' 
  echo -e '  -i|--interactive  gives the user options to interactive select a specific interface'
  echo -e '  -s|--select <iface> filter by the specific iface given'
  echo -e '  -nci|--not-config-iface allow search even the iface specified in the --select option is not a configure iface\n'
  exit 0
}

function grep_iface () {
  local iface="$1"

  grep -w "$iface" "$file"
}

function interactive_select() {
  PS3='Choose an interface to filter '
  select iface in $ifaces; do
    echo "Filter by $iface interface:"
    grep_iface "$iface"
    exit 0
  done
}

function all_ifaces() {
  while read iface; do
    grep_iface "$iface"
  done < <(echo "$ifaces")
}

function check_iface() {
  [[ -n "$allow_not_config_iface" ]] && return 

  for i in ${ifaces[@]}; do
    [[ "$i" == "$selected_iface" ]] && return
  done

  echo -e "$err_msge No such iface configure" && exit 1
}

while [[ $# -gt 1 ]]; do
  case "$1" in
    -i|--interactive)
      select_mode=interactive
      ;;
    -s|--select)
      select_mode=manual
      shift
      selected_iface="$1"
      ;;
    -h|--help) 
      print_help
      ;;
    -nci|--not-config-iface)
      allow_not_config_iface=yes	    
      ;;
    *) 
      echo -e "$err_msge Invalid option given: $1"
      exit 1
      ;;	    
  esac
  shift    	  
done

[[ -z "$1" ]] && echo -e "$err_msge No file given" && exit 1

[[ "$1" =~ ^(-h|--help)$ ]] && print_help && exit 0

[[ ! -f "$1" ]] && echo -e "$err_msge Either file does not exist or is not a regular file" && exit 1

file="$1"

[[ -n "$selected_iface" ]] && check_iface

case "$select_mode" in
  interactive) interactive_select ;;
  manual) grep_iface "$selected_iface" ;;
  *) all_ifaces ;;
esac

exit 0
