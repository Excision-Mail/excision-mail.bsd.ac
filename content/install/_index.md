+++
title = "Installation overview"
author = ["Aisha Tammy"]
lastmod = 2020-06-16T15:48:44-04:00
draft = false
weight = 1000
+++

## Overview
- [Set up vars](#vars)
- [Set up the inventory](#inventory)
- [Execute site-preinstall playbook](#preinstall)
- [Execute site-install playbook](#install)
- [Execute site-extras playbook](#extras) (optional)

## Set up vars.yml {#vars}

It is recommended to first start with a minimal configuration of only the necessities and then re-run the installation to enable the optional extras.

{{% notice info %}}
A detailed description of each option is given in the [vars-sample.yml](https://github.com/Excision-Mail/Excision-Mail/blob/master/vars-sample.yml) file.
{{% /notice %}}

A minimal configuration using the optional, but highly recommended, [nsd(8)](https://man.openbsd.org/nsd.8) setup would be similar to:

{{< highlight yaml "linenos=table, linenostart=1" >}}
hostname: mail.aisha.cc
admin: aisha

domains:
  - name: aisha.cc
    nsd: true

enable_nsd: true

# ip1
ipv4: 108.61.81.40
ipv6: 2001:19f0:5:36b:5400:2ff:fe7f:a634

# ip2
secondary_nameservers:
        - ipv4: 69.65.50.192 # freedns2
        - ipv4: 109.201.133.111 # rest are cloudns
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
        - name: freedns2 # freedns2
          ipv4: 66.65.50.223
        - name: pns31 # rest are cloudns
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

## Set up the inventory {#inventory}

If you are running Ansible on the mail server, the default `inventory-sample.ini` should be enough. Just copy and rename the file to `inventory.ini` and it should work.

{{< highlight ini "linenos=table, linenostart=1" >}}
[extraserver]
extra ansible_connection=local ansible_python_interpreter=/usr/local/bin/python3

[mainserver]
extra ansible_connection=local ansible_python_interpreter=/usr/local/bin/python3

[global:children]
extraserver
mainserver
{{< /highlight >}}


## Execute site-preinstall playbook {#preinstall}

The first playbook to run is the `site-preinstall.yml`:

```sh
$ ansible-playbook site-preinstall.yml
```

This runs the following preliminary roles (in order) for a basic setup:

- [base](https://github.com/Excision-Mail/Excision-Mail/tree/master/roles/base):
    - Set up logging, login and cron jobs.
    - Deploys `excision` commands
    - Sets up [MTA STS](https://datatracker.ietf.org/doc/html/rfc8461), [OpenPGP Web Key Service](https://wiki.gnupg.org/WKS) and client autodiscovery infrastructure
- [pf](https://www.openbsd.org/faq/pf/)
    - Sets up basic [pf(5)](https://man.openbsd.org/pf.conf.5) firewall rules
- [syslog](https://github.com/Excision-Mail/ansible-syslog)
    - Configures [syslogd(8)](https://man.openbsd.org/syslogd.8).
- [knot](https://github.com/Excision-Mail/Excision-Mail/tree/develop/roles/knot) (optional, highly recommended)
    - Sets up [knot DNS](https://www.knot-dns.cz/) for all domains with `dns` option enabled and configures an authoritative nameserver for [Stealth master](../guides/secondary/#stealth-master) setup
- [zones](https://github.com/Excision-Mail/Excision-Mail/tree/develop/roles/zones) (optional, highly recommended)
    - Generate DNS zone files for knot
    - Generates DKIM certificates

{{% notice info %}}
It will take about 10-15 minutes after running the **site-preinstall** role for the DNS changes to be in effect. Running the **site-install** role too soon may cause it to abort as Lets Encrypt may not be able to find the websites.
{{% /notice %}}

If you skipped the setup and configuration of [knot](https://github.com/Excision-Mail/Excision-Mail/tree/develop/roles/knot), you should now follow the [Manual DNS Setup](../guides/manualdns/) guide to create the DNS records in your provider's interface. For DKIM keys, login to the mailserver and create DKIM keys manually with:

```sh
$ excision ensure-dkim
```
Add the TXT records `excisionRSA._domainkey` (for outgoing mails signed by `rspamd`) and `davRSA._domainkey` (optional, for outgoing scheduling requests by `davical`) with the values shown in the above command's output.

## Execute site-install playbook {#install}

The buld of the work is done in the `site-install.yml` playbook:

```sh
$ ansible-playbook site-install.yml
```

The following roles are run (in order):

- [nginx_core](https://github.com/Excision-Mail/ansible-nginx)
    - Installs [nginx](https://www.nginx.com/) and configures basic webserver settings
    - Web server for all domains and subdomains
- [acme](https://github.com/Excision-Mail/Excision-Mail/tree/develop/roles/acme):
    - Creates the *SSL* certificates with [acme-client(1)](https://man.openbsd.org/man1/acme-client.1).
- [nginx_main_sites](https://github.com/Excision-Mail/Excision-Mail/tree/develop/roles/nginx_extra_sites)
    - Configures nginx to serve ACME challenges, [MTA STS](https://datatracker.ietf.org/doc/html/rfc8461) information, [OpenPGP Web Key Service](https://wiki.gnupg.org/WKS) and client autodiscovery.
- [openldap](https://github.com/Excision-Mail/ansible-openldap) (work in progress)
    - Sets up LDAP for all services to bind against (support in OpenSMTPD pending)
- [spamd](https://github.com/Excision-Mail/Excision-Mail/tree/master/roles/spamd) (optional):
    - Sets up grey listing and tarpitting for spam protection.
- [redis](https://github.com/Excision-Mail/ansible-redis)
    - Sets up redis for use in rspamd
- [clamav](https://github.com/Excision-Mail/Excision-Mail/tree/master/roles/clamav) (optional):
    - Sets up an antivirus which scans all attachments and emails.
    - **WARNING**: this is quite heavy and may cripple smaller servers.
- [rspamd](https://github.com/Excision-Mail/Excision-Mail/tree/master/roles/rspamd):
    - Gives a *lot* of spam protection setup techniques.
    - Enables DKIM signing for outgoing mails.
- [smtpd](https://github.com/Excision-Mail/Excision-Mail/tree/master/roles/smtpd):
    - Finally sets up the actual OpenSMTPD MTA.
- [dovecot](https://github.com/Excision-Mail/Excision-Mail/tree/master/roles/dovecot):
    - Sets up the IMAP/POP3 servers.
    - Sets up the local MDA for virtuals users.

## Execute site-extras playbook (optional) {#extras}

This enables extra functionality that is not inherently needed for an email server but has become ubiquitous for almost all email setups.

```sh
$ ansible-playbook site-extra.yml
```

This installs and configures (in order):

- [php](https://github.com/Excision-Mail/Excision-Mail/tree/master/roles/php)
- [postgresql](https://github.com/Excision-Mail/Excision-Mail/tree/master/roles/postgresql)
- [davical](https://github.com/Excision-Mail/Excision-Mail/tree/master/roles/davical): Calendar + contacts server
- [roundcube](https://github.com/Excision-Mail/Excision-Mail/tree/master/roles/roundcube): Webmail server, along with a managesieve plugin for server side mail filtering.
