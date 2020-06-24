+++
title = "Backups"
author = ["Aisha Tammy"]
lastmod = 2020-06-16T15:48:50-04:00
draft = false
weight = 1015
+++

# System Backup



## non-replaceable files {#non-replaceable-files}

These files are generated over time when using Excision and cannot be restored by the ansible scripts

```sh linenostart=1
# excision config files folder
/etc/excision/
# excision-passwd home folder
#  - contains ssh keys of users
/var/excision-passwd/
# excision user home folder
#  - contains important gpg keys
/var/excision-home/
# published gpg keys of users
/var/www/openpgpkey/
# and of course, the whole mails folder
/var/excision/
```
