+++
title = "FreeDNS setup"
author = ["epsilon"]
draft = false
+++

## FreeDNS (afraid.org) {#freedns--afraid-dot-org}

Example setup for stealth master configuration using freedns.afraid.org


### FreeDNS configuration {#freedns-configuration}

First make an account on FreeDNS and then go to add **backup dns**:<br />
<https://freedns.afraid.org/secondary/add.php>

{{< figure src="/images/freedns_secondary_add.png" >}}


### Secondary servers {#secondary-servers}

The information related to secondary nameservers is available on their website:
<https://freedns.afraid.org/secondary/instructions.php>

{{< figure src="/images/freedns_secondary_info.png" >}}

****NOTE****: This still hasn't given you the ip of ns2.afraid.org. You should poke around on their website to find the relevant information or use the \`host\` command on OpenBSD to get the ip addresses of ns2.afraid.org
\`\`\`
$ host ns2.afraid.org
ns2.afraid.org has address 69.65.50.223
ns2.afraid.org has IPv6 address 2001:1850:1:5:800::6b
\`\`\`


## Registrar configuration (namecheap) {#registrar-configuration--namecheap}

You can set up the configuration at your registrar, depending on your provider.
E.g. on NameCheap:

{{< figure src="/images/namecheap_dns_configuration.png" >}}


## AnsiMail configuration {#ansimail-configuration}

A full vars.yml file as an example is:

{{< highlight yaml "linenos=table, linenostart=1" >}}
domain: aisha.cc
hostname: mail
admin: aisha

additional_domains:
        - name: epsilonknot.xyz
        - name: bsd.ac
          nsd: true

private_interface: tun0

# ip1
ipv4: 108.61.81.40
ipv6: 2001:19f0:5:36b:5400:2ff:fe7f:a634

enable_clamav: true
enable_spamd: true
enable_nsd: true
username_delimiter: "."
rspamd_enable_pretrain: true

additional_udp_ports:
        - 161

# ip2
secondary_nameservers:
        - ipv4: 69.65.50.192 # freedns2
        - ipv6: 2001:1850:1:5:800::6b # freedns2
        - ipv4: 109.201.133.111 # ALL rest are cloudns
        - ipv4: 209.58.140.85
        - ipv4: 54.36.26.145
        - ipv4: 185.206.180.104
        - ipv4: 185.136.96.66
        - ipv4: 185.136.97.66
        - ipv4: 185.136.98.66
        - ipv4: 185.136.99.66
        - ipv4: 185.206.180.193
        - ipv6: 2a00:1768:1001:9::31:1
        - ipv6: 2605:fe80:2100:a013:7::1
        - ipv6: 2a0b:1640:1:1:1:1:8ec:5a47
        - ipv6: 2a06:fb00:1::1:66
        - ipv6: 2a06:fb00:1::2:66
        - ipv6: 2a06:fb00:1::3:66
        - ipv6: 2a06:fb00:1::4:66
        - ipv6: 2a0b:1640:1:3::1

# ip3
public_nameservers:
        - name: freedns2 # this is freedns2
          ipv4: 66.65.50.223
          ipv6: 2001:1850:1:5:800::6b
        - name: pns31 # ALL are cloudns
          ipv4: 185.136.96.66
          ipv6: 2a06:fb00:1::1:66
        - name: pns32
          ipv4: 185.136.97.66
          ipv6: 2a06:fb00:1::2:66
        - name: pns33
          ipv4: 185.136.98.66
          ipv6: 2a06:fb00:1::3:66
        - name: pns34
          ipv4: 185.136.99.66
          ipv6: 2a06:fb00:1::4:66
        - name: ns31
          ipv4: 109.201.133.111
          ipv6: 2a00:1768:1001:9::31:1
        - name: ns32
          ipv4: 209.58.140.85
          ipv6: 2605:fe80:2100:a013:7::1
        - name: ns33
          ipv4: 54.36.26.145
        - name: ns34
          ipv4: 185.206.180.104
          ipv6: 2a0b:1640:1:1:1:1:8ec:5a47
{{< /highlight >}}
