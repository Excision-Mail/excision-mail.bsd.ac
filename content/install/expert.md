+++
title = "Expert Installation"
author = ["Aisha Tammy"]
draft = false
weight = 1001
+++

## Overview
The overall structure is similar to the standard installation process, wherein you run the three roles in order.<br>
The only catch here is that the installation is going to be on two separate servers, which necessitates a more complex `vars.yml` file.

## Architecture overview
{{< chart [90] [30] >}}
{
    type: 'bar',
    data: {
        labels: [ 'Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange' ],
        datasets: [{
            label: 'Bar Chart',
            data: [12, 19, 18, 16, 13, 14],
            backgroundColor: [
                'rgba(255, 99, 132, 0.2)',
                'rgba(54, 162, 235, 0.2)',
                'rgba(255, 206, 86, 0.2)',
                'rgba(75, 192, 192, 0.2)',
                'rgba(153, 102, 255, 0.2)',
                'rgba(255, 159, 64, 0.2)'
            ],
            borderColor: [
                'rgba(255, 99, 132, 1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)'
            ],
            borderWidth: 1
        }]
    },
    options: {
        maintainAspectRatio: false,
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero: true
                }
            }]
        }
    }
}
{{< /chart >}}


## Set up vars.yml {#vars}

An example `vars.yml` for the above installation:

{{< highlight yaml "linenos=table, linenostart=1" >}}
hostname: mail.aisha.cc
admin: aisha

domains:
  - name: aisha.cc
    nsd: true
  - name: epsilonknot.xyz
    nsd: true
  - name: bsd.ac
    nsd: true

enable_nsd: true

username_delimiter: "."

enable_spamd: true

rspamd_enable_pretrain: true

private_interface: wg0
enable_extras: true
extras_not_home: true
extras_interface: wg0
extras_ip: 10.7.0.3

# needed as second server is a -current server
# which has a newer version of php set as default
php_pkg_version: 7.3.22

pgsql_password_roundcube: prollySOMEpassword
rc_encryption_key: somethingsomethingencrypt

davical_dba_password: "somedavicalpassword!!!!"
davical_app_password: "someotherdavicalappPASSWD123123"
davical_tmp_admin_password: "sup3rc00ltempPASSWD"

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
          ipv6: 2001:1850:1:5:800::6b
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

{{< highlight ini "linenos=table, linenostart=1" >}}
# this is a -current server
[extraserver]
extra ansible_host=10.7.0.3 ansible_python_interpreter=/usr/local/bin/python3.9

[mainserver]
main ansible_host=10.7.0.1 ansible_python_interpreter=/usr/local/bin/python3.8

[global:children]
extraserver
mainserver
{{< /highlight >}}


## Execute the playbook roles {#roles}
