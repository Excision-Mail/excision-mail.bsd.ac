+++
title = "Secondary nameserver overview"
author = ["Aisha Tammy"]
lastmod = 2020-06-16T15:48:47-04:00
draft = false
weight = 1011
+++

## Secondary and Primary DNS explanations {#secondary-and-primary-dns-explanations}

First let us look at the big picture of the stealth master configuration of a DNS server

-   **LARGE, SMALL, MEDIUM** show the computing capabilities of the server.

<!--listend-->

```nil
-------------------                  -----------------------              ---------------------
|    (SMALL)      |    NOTIFY        |     (MEDIUM)        |   (internal) |    (LARGE)        |
|    Personal     | ---------------> |     Secondary DNS   |<------------>|   Public facing   |
|      VPS        | <--------------- |       server IP     |              |     DNS server    |
|     [ip1]       |    AXFR request  |       [ip2]         |              |      [ip3]        |
-------------------                  -----------------------              ---------------------
       |                                                                            ^  |
       ---------------------------------------------------                          |  |
          two way communication between VPS and user      |                         |  |
                                                          |                         |  |
              -------------------  primary NS query --------------                  |  |
              |     (LARGE)     | <---------------  |    (USER)  |  domain ip query |  |
              |    Registrar    | --------------->  |     user   | ------------------  |
              |                 |   ip3 as primary  |            |<---------------------
              -------------------        NS         --------------     ip1 as address
                                                                          of domain
```


## Quick overview of DNS {#quick-overview-of-dns}

DNS stands for **domain name server/system** and is the first step in establishing communication with a host.<br />
DNS is the method to translate a name of the form _<https://openbsd.org>_ to an ipv4 address, which can be of
the form **129.128.5.194** or an ipv6 address, which is a lot more complex, of the form **dead::beef**.


## DNS flow overview {#dns-flow-overview}

A user does not necessarily store all the translation information in their local server.<br />
The way a user gets this translation is by querying **primary nameservers** of the domain and making query for the ip of the domain.


### Primary nameservers {#primary-nameservers}

**Primary nameservers** are the one which answer the users query for the _ip_ of a domain.<br />
These are queried millions of times a second from different places for different
domains, hence they are hosted on highly powerful computers.

For the first step, even before communicating with the server, the user must know the _ip_ address of the primary nameservers.<br />
The user gets the **primary nameserver** by querying different _registrars_ for the primary nameserver of a domain.<br />
There are a lot of registrars and they have their own methods of making sure that the information between registrars is in sync.
Typically, you update the _ip_ addresses of the primary nameservers at **your registrar**, where you bought the domain name from,
and this information is synced all throughout the world very soon (we don't cover explaining _recursive dns_ and other complex things here).<br />
This way it is fairly fast for a user to get the **primary nameservers** of your domain.


### Secondary nameservers {#secondary-nameservers}

But how does the _primary nameserver_ get the information?

The answer to that is the **stealth master configuration**.<br />
The DNS service provider will query your personal VPS for all the information and then will start answering the queries of users.

But the DNS provider does **not** do this through the same servers that it answers queries from.<br />
It is done via other _medium_ sized servers, which are called **secondary nameservers**, who query your VPS in two ways

-   Either by doing queries periodically, or
-   Your VPS sends a notification (**NOTIFY**) to the secondary nameserver, informing them that some change has happened and it should query you asap.

The second method is called the **NOTIFY** from your VPS to the secondary DNS.<br />
Hence it is vital to get the DNS service from a provider who supports the **NOTIFY** protocol.

The query made by the secondary nameserver is called a **zone transfer, AXFR,** query, wherein it asks your VPS for the full zone file of the domain.<br />
This method to query for the zone file of a domain from a computer has been exploited to do DDOS attacks and
needs careful adjustment to only allow the proper IPs to make **AXFR** requests.

Now the DNS providers secondary nameserver will take your zone file and then update the public facing nameservers fairly soon (typically <5 mins).


## Stealth master {#stealth-master}

For the DNS provider to get the full zone info, it first needs the _IP_ address of your VPS.  <br />
This is one of the reasons why hosting services at home is a tough situation as your home address is fairly fickle.

Hence your VPS is the **master** provider of the DNS information, but because it is a small server, we delegate the
responsibility to answer the users queries to the _LARGE_ servers from your DNS service provider.

None of the users ever know that the actual authoritative information is coming stored in a different location,
_your VPS server_, hence it is called a **stealth master**.


## Excision setup {#excision-setup}

Excision does this automatically provided that you give the **ip2** and **ip3** in the configuration.

-   **ip2** - This is the address that is allowed to make **AXFR** requests and also the address that **NOTIFY** updates are sent to
-   **ip3** - This is added in the zone file for a cross check with your registrar to make sure that the proper nameservers are used.

Typically, when you buy a DNS service, they will have the information of the public facing
nameservers and the secondary namerservers, somewhere in their web ui.<br />
Just take the two lists of ip addresses and add them in the appropriate place in the vars.yml file.
