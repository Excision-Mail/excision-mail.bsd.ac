+++
title = "Excision Mail"
author = ["Aisha Tammy"]
lastmod = 2020-06-16T15:48:40-04:00
categories = ["main"]
draft = false
+++

# Excision Mail {#excision-mail}

Fullstack, security focused mailserver based on OpenSMTPD for OpenBSD.

{{% notice info %}}
Website is still a WIP but feel free to explore and give feedback.
{{% /notice %}}

## Security Highlights

- All connections are TLS enforced, including `pop3s`, `imaps`, `smtps`.
  - `smtp` and `sieve` are [**STARTTLS**](https://en.wikipedia.org/wiki/Opportunistic_TLS#SSL_ports) with enforced TLS escalation.
  - Insecure versions of `pop3` and `imap` are disabled for additional security.
- [GnuPG](https://gnupg.org/) [Web Key Service](https://wiki.gnupg.org/WKS) and [Web Key Directory](https://wiki.gnupg.org/WKD) support for automatic publishing of public keys in a multi-domain server setting.
  - Server only contains public keys of user, so encrypted emails can only be decrypted by the user.
  - Currently the **only** email deployment service which handles automated publishing of GPG keys.
- [**mta-sts**](https://tools.ietf.org/html/rfc8461) for fully encrypted email transfer channels.
- Virtual users for email, to separate from base system.
  - Imperative for any modern email system, in case of a compromised user account.
- Hardened firewall to deter hackers sniffing for weak passwords.

## Documentation

The documentation covers various aspects of the system

{{% notice info %}}
A lot of the documentation is underwritten and not up to the desired standard.  
Any help writing it is appreciated.
{{% /notice %}}

- [Installation](install)
- THE [**excision**](excision) command
- [Overview](overview)
  - [System architecture](overview/system)
  - [Virtual users](overview/users)
  - [Spam detection](overview/spam)
  - [GPG publishing](overview/gpg)
  - [Domain Name Server (stealth primary)](overview/nsd)
- [Backups](backups)
