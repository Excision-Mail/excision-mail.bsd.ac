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

{{< highcharts-custom chart="expert_map" height="700" width="1000" >}}
        chart: {
        backgroundColor: 'white',
        events: {
            load: function () {

                // Draw the flow chart
                var ren = this.renderer,
                    colors = Highcharts.getOptions().colors,
                    rightArrow = ['M', 0, 0, 'L', 100, 0, 'L', 95, 5, 'M', 100, 0, 'L', 95, -5],
                    leftArrow = ['M', 100, 0, 'L', 0, 0, 'L', 5, 5, 'M', 0, 0, 'L', 5, -5];


                // Separator, client from service
                ren.path(['M', 120, 40, 'L', 120, 330])
                    .attr({
                        'stroke-width': 2,
                        stroke: 'silver',
                        dashstyle: 'dash'
                    })
                    .add();

                // Separator, CLI from service
                ren.path(['M', 420, 40, 'L', 420, 330])
                    .attr({
                        'stroke-width': 2,
                        stroke: 'silver',
                        dashstyle: 'dash'
                    })
                    .add();

                // Headers
                ren.label('Web client', 20, 40)
                    .css({
                        fontWeight: 'bold'
                    })
                    .add();
                ren.label('Web service / CLI', 220, 40)
                    .css({
                        fontWeight: 'bold'
                    })
                    .add();
                ren.label('Command line client', 440, 40)
                    .css({
                        fontWeight: 'bold'
                    })
                    .add();

                // SaaS client label
                ren.label('SaaS client<br/>(browser or<br/>script)', 10, 82)
                    .attr({
                        fill: colors[0],
                        stroke: 'white',
                        'stroke-width': 2,
                        padding: 5,
                        r: 5
                    })
                    .css({
                        color: 'white'
                    })
                    .add()
                    .shadow(true);

                // Arrow from SaaS client to Phantom JS
                ren.path(rightArrow)
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[3]
                    })
                    .translate(95, 95)
                    .add();

                ren.label('POST options in JSON', 90, 75)
                    .css({
                        fontSize: '10px',
                        color: colors[3]
                    })
                    .add();

                ren.label('PhantomJS', 210, 82)
                    .attr({
                        r: 5,
                        width: 100,
                        fill: colors[1]
                    })
                    .css({
                        color: 'white',
                        fontWeight: 'bold'
                    })
                    .add();

                // Arrow from Phantom JS to Batik
                ren.path(['M', 250, 110, 'L', 250, 185, 'L', 245, 180, 'M', 250, 185, 'L', 255, 180])
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[3]
                    })
                    .add();

                ren.label('SVG', 255, 120)
                    .css({
                        color: colors[3],
                        fontSize: '10px'
                    })
                    .add();

                ren.label('Batik', 210, 200)
                    .attr({
                        r: 5,
                        width: 100,
                        fill: colors[1]
                    })
                    .css({
                        color: 'white',
                        fontWeight: 'bold'
                    })
                    .add();

                // Arrow from Batik to SaaS client
                ren
                    .path([
                        'M', 235, 185,
                        'L', 235, 155,
                        'C', 235, 130, 235, 130, 215, 130,
                        'L', 95, 130,
                        'L', 100, 125,
                        'M', 95, 130,
                        'L', 100, 135
                    ])
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[3]
                    })
                    .add();

                ren.label('Rasterized image', 100, 110)
                    .css({
                        color: colors[3],
                        fontSize: '10px'
                    })
                    .add();

                // Browser label
                ren.label('Browser<br/>running<br/>Highcharts', 10, 180)
                    .attr({
                        fill: colors[0],
                        stroke: 'white',
                        'stroke-width': 2,
                        padding: 5,
                        r: 5
                    })
                    .css({
                        color: 'white',
                        width: '100px'
                    })
                    .add()
                    .shadow(true);


                // Arrow from Browser to Batik
                ren.path(rightArrow)
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[1]
                    })
                    .translate(95, 205)
                    .add();

                ren.label('POST SVG', 110, 185)
                    .css({
                        color: colors[1],
                        fontSize: '10px'
                    })
                    .add();

                // Arrow from Batik to Browser
                ren.path(leftArrow)
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[1]
                    })
                    .translate(95, 215)
                    .add();

                ren.label('Rasterized image', 100, 215)
                    .css({
                        color: colors[1],
                        fontSize: '10px'
                    })
                    .add();

                // Script label
                ren.label('Script', 450, 82)
                    .attr({
                        fill: colors[2],
                        stroke: 'white',
                        'stroke-width': 2,
                        padding: 5,
                        r: 5
                    })
                    .css({
                        color: 'white',
                        width: '100px'
                    })
                    .add()
                    .shadow(true);

                // Arrow from Script to PhantomJS
                ren.path(leftArrow)
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[2]
                    })
                    .translate(330, 90)
                    .add();

                ren.label('Command', 340, 70)
                    .css({
                        color: colors[2],
                        fontSize: '10px'
                    })
                    .add();

                // Arrow from PhantomJS to Script
                ren.path(rightArrow)
                    .attr({
                        'stroke-width': 2,
                        stroke: colors[2]
                    })
                    .translate(330, 100)
                    .add();

                ren.label('Rasterized image', 330, 100)
                    .css({
                        color: colors[2],
                        fontSize: '10px'
                    })
                    .add();

            }
        }
    },
    title: {
        text: 'Excision Mail: Distributed Setup',
        style: {
            color: 'black'
        }
    },
    accessibility: {
        typeDescription: 'Flowchart'
    }
{{< /highcharts-custom >}}

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
