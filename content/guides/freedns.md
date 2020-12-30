+++
title = "FreeDNS setup"
author = ["Aisha Tammy"]
lastmod = 2020-06-16T15:48:48-04:00
draft = false
weight = 1012
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

**NOTE**: This still hasn't given you the ip of ns2.afraid.org. You should poke around on their website to find the relevant information or use the `host` command on OpenBSD to get the ip addresses of ns2.afraid.org.
{{< highlight shell "linenos=table, linenostart=1" >}}
$ host ns2.afraid.org
ns2.afraid.org has address 69.65.50.223
ns2.afraid.org has IPv6 address 2001:1850:1:5:800::6b
{{</highlight>}}

## Registrar configuration (namecheap) {#registrar-configuration--namecheap}

You can set up the configuration at your registrar, depending on your provider.
E.g. on NameCheap:

{{< figure src="/images/namecheap_dns_configuration.png" >}}
