# Bash scripts utils

Some useful bash scripts to use in everydays work. These scripts follows the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html#s6.3-tests) with some slight differences in some cases. In all cases, you can set `-h` or `--help` option to see a brief description and usage

### Short description

1. [ifacelogs](https://github.com/ColoJose/bash-script-utils/blob/main/src/ifacelogs.sh): takes a file and returns all lines which matches configured netowrk interfaces
2. [ping_discovery](https://github.com/ColoJose/bash-script-utils/blob/main/src/ping_discovery.sh): makes a host discovery sending ARP packet using the network interface IP address and network mask to generate the list of target host addresses network. After this, send and ICMP ECHO Request to see if each discovered supports this service or inform the problem ocurred.

