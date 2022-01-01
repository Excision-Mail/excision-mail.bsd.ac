+++
title = "Web Key Directory and Service"
author = ["Aisha Tammy"]
draft = false
weight = 1014
+++

**Web Key Directory** is a method of public key discovery through HTTPS. **Web Key Service** is a protocol to allow users to publish their public key to a WKD server.

Excision Mail comes with a setup of [Web Key Directory (WKD)](https://wiki.gnupg.org/WKD) and GnuPG [Web Key Service (WKS)](https://wiki.gnupg.org/WKS) which work out of the box for all providers and consumers, allowing publication of PGP keys on the mail hosting server, as opposed to centralized keyservers. One of the key advantages of PGP is to decentralize information to build a web of trust, hence hosting a WKD plays a vital part in ensuring a rich ecosystem. The [WKD/WKS RFC](https://datatracker.ietf.org/doc/html/draft-koch-openpgp-webkey-service) details the technical specifications to *host* a WKD server. This documentaion only goes over the user side setup, showing how a user can publish their PGP key to the Excision Mail system.

To publish a key using WKS, a mail client is required. Many mail clients support the GnuPG-WKS protocol, such as [KMail](https://apps.kde.org/kmail2/), [mutt](http://www.mutt.org/), [neomutt](https://neomutt.org/), [Claws Mail](https://www.claws-mail.org/) (through the [enigmail](https://www.enigmail.net/index.php/en/) plugin).

## NeoMutt

This configuration setup uses [mutt-wizard](https://github.com/LukeSmithxyz/mutt-wizard) a very handy setup to configure NeoMutt, which should work for most users. The OpenBSD package also supports WKD/WKS out of the box.

The general outline of the process:

1. Add an account using mutt-wizard.   
    While adding an account, specify the port as `587`.
2. Create a GnuPG key (or skip if already exists).
3. Start neomutt and start the key publishing request - `Alt + g`.
4. Receive a verification request.
    Press `o` (small-oh) to sync mail.
5. Send a mail confirming publication - `Alt + h` (while selecting the confirmation email).
6. Receive a return confirmation mail.
7. Manually verify that the key has been published

```
$ mw -a test-user@bsd.ac -S 587
Give your email server's IMAP address (excluding the port number):
imap.bsd.ac
Give your email server's SMTP address (excluding the port number):
smtp.bsd.ac
Enter password for test-user@bsd.ac: 
Retype password for test-user@bsd.ac: 
test-user (account #1) added successfully.

$ mw -l
	1  test-user@bsd.ac

$ gpg --quick-generate-key test-user@bsd.ac
About to create a key for:
    "test-user@bsd.ac"

Continue? (Y/n)
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
...
...
...

$ neomutt

<Alt + g>
...
...
...
Enter email ID of user to publish: test-user@bsd.ac
Enter fingerprint of GPG key to publish: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
gpg-wks-client: submitting request to 'wks@bsd.ac'

<o> # small-oh

	1 Ns+   21/10/31 06:58PM wks@bsd Confirm your key publication (2.4K)

<Alt + h> # the confirmation request should be selected

<o> # small-oh

	1 NP+   21/10/31 07:02PM wks@bsd Your key has been published (1.5K)

```
