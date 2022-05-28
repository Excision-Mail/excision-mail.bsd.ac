#!/bin/sh

hugo -D

cdate="$(date)"

cd excision-mail.github.io
git add .
git commit -m "update for ${cdate}"
git push
cd ..

git add .
git commit -m "update for ${cdate}"
git push

ssh excision.bsd.ac <<EOF
cd excision
git pull
EOF
