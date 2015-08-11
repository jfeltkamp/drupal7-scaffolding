#!/bin/bash
DOMAIN=$1
ROOTPATH=$2

# Sync all files from deploy server to webserver
rsync -e "ssh -o StrictHostKeyChecking=no" -v --perms --checksum --omit-dir-times --compress --recursive --links --executability -D --delete-after --exclude-from ./deploy/rsync_exclude.txt . ${DOMAIN}:${ROOTPATH}

DRUPALPATH="${ROOTPATH}/drupal"
ssh ${DOMAIN} 'cd ${DRUPALPATH}; drush cc all'