+++
title = "Backup"
author = ["Aisha Tammy"]
draft = false
+++

list of things to backup


## non-replaceable files {#non-replaceable-files}

These files are generated over time when using AnsiMail and cannot be restored by the ansible scripts

{{< highlight sh "linenos=table, linenostart=1" >}}
# ansimail config files folder
/etc/ansimail/
# ansimail-passwd home folder
#  - contains ssh keys of users
/var/ansimail-passwd/
# ansimail user home folder
#  - contains important gpg keys
/var/ansimail-home/
# published gpg keys of users
/var/www/openpgpkey/
# and of course, the whole mails folder
/var/ansimail/
{{< /highlight >}}
