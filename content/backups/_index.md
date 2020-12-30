+++
title = "System Backups"
author = ["Aisha Tammy"]
lastmod = 2020-06-16T15:48:50-04:00
draft = false
weight = 1015
+++

## Important non-replaceable files {#ifiles}

These files are generated over time when using Excision and cannot be restored by the ansible scripts

```sh
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

# and of course, the whole email folder
/var/excision/
```

## Backup using restic

Here is a sample configuration using [restic](https://restic.net/) which backs up the desired folders to a remote repo in `/etc/daily.local`

```sh
# set up a restic repo somewhere which can be accessed
# using your desired method
RESTIC_REPO="sftp:truenas:/mnt/Media/backups/mail.aisha.cc"
env RESTIC_PASSWORD_FILE="/root/.ssh/restic" \
HOME="/root" \
/usr/local/bin/restic --repo ${RESTIC_REPO} \
	--verbose backup \
	--exclude-if-present=no_restic \
	--exclude-file=/etc/restic.exclude \
	--files-from=/etc/restic.include \
	--tag="$(date +%c)"

# list changes
PREV=$(env RESTIC_PASSWORD_FILE="/root/.ssh/restic" HOME="/root" \
	/usr/local/bin/restic --repo ${RESTIC_REPO} \
	snapshots --compact | tail -4 | head -1 | awk '{print $1}')
LAST=$(env RESTIC_PASSWORD_FILE="/root/.ssh/restic" HOME="/root" \
	/usr/local/bin/restic --repo ${RESTIC_REPO} \
	snapshots --compact | tail -3 | head -1 | awk '{print $1}')

RDIFF_FILE="/tmp/rdiff.${RANDOM}"
env RESTIC_PASSWORD_FILE="/root/.ssh/restic" HOME="/root" \
	/usr/local/bin/restic --repo ${RESTIC_REPO} \
	diff ${PREV} ${LAST} > ${RDIFF_FILE}

NLINES=$(wc -l "${RDIFF_FILE}" | awk '{print $1}')
if [ $NLINES -gt 108 ] ; then
	head -n 100 ${RDIFF_FILE}
	printf "======= SNIP ======\n"
	tail -n 8 ${RDIFF_FILE}
else
	cat ${RDIFF_FILE}
fi
rm -f ${RDIFF_FILE}
unset RDIFF_FILE RESTIC_REPO NLINES
```

The recommended `restic.include` :
```
/bin
/etc
/home
/root
/sbin
/usr
/var
```

and `/etc/restic.exclude` :
```
/var/run
```