# Bash scripts utils

Some useful bash scripts to use in everydays work. These scripts follows the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html#s6.3-tests) with some slight differences in some cases. In all cases, you can set `-h` or `--help` option to see a brief description and usage

### Short description

1. [ifacelogs](https://github.com/ColoJose/bash-script-utils/blob/main/src/ifacelogs.sh): takes a file and returns all lines which matches configured netowrk interfaces
2. [arp_host_discovery](https://github.com/ColoJose/bash-script-utils/blob/main/src/arp_host_discovery.sh): makes a host discovery sending ARP packets. After this, send and ICMP ECHO Request to each discovered host in order to show if it supports this service or inform the problem ocurred.
