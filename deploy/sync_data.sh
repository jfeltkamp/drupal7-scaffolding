#!/bin/bash
set -e

BASEDIR=$(dirname "$0")
DRUPAL_ROOT="${BASEDIR}/../drupal"

FILES_FOLDER="/drupal/sites/default/files"
FILES_FOLDER_REL="${BASEDIR}/..${FILES_FOLDER}"

BAM_FOLDER="/drupal/sites/default/files/private/backup_migrate/manual"
BAM_FOLDER_REL="${BASEDIR}/..${BAM_FOLDER}"

ENV_FOLDER="${BASEDIR}/../env"
. ${ENV_FOLDER}/.env

echo "WARNING: Are you sure to sync data from LIVE to this environment?"
echo "- DATA from your current database can be lost."
echo "- FILES from your current enviroment can be lost."

read -r -p "Please confirm to run data-sync (y/n): " RESPONSE
echo
if [ ${RESPONSE} = "y" -o ${RESPONSE} = "Y" ]; then

    ##################################
    # SYNC files folder
    ##################################

    # IF THERE ARE RIGHTS ISSUES ON YOUR LOCAL SYSTEM UNCOMMENT THE FOLLOWING LINES
    # BE CAREFULL!!! SAVE ALL FILES AND A DATABASE DUMP BEFORE !!!
    # rm -Rf "${FILES_FOLDER_REL}"
    # mkdir ${FILES_FOLDER_REL}

    # HTTPDUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`

    # if hash chmod 2>/dev/null; then
    #     chmod +a "$HTTPDUSER allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs
    #     chmod +a "`whoami` allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs
    # else
    #     setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX ${FILES_FOLDER_REL}
    #     setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX ${FILES_FOLDER_REL}
    # fi


    rsync -e "ssh -o StrictHostKeyChecking=no" -v --perms --checksum --omit-dir-times --compress --recursive --links --executability -D --delete-after --exclude-from ${BASEDIR}/rsync_data_exclude.txt "${LEAD_USER}@${LEAD_DOMAIN}:${LEAD_ROOT}${FILES_FOLDER}/" "${FILES_FOLDER_REL}/"

    ##################################
    # SYNC database backup  folder
    ##################################

    ssh -o StrictHostKeyChecking=no ${LEAD_USER}@${LEAD_DOMAIN} sh ${LEAD_ROOT}/deploy/remote/backup_db.sh

    # IF THERE ARE RIGHTS ISSUES ON YOUR LOCAL SYSTEM UNCOMMENT THE FOLLOWING LINES
    # BE CAREFULL!!! SAVE ALL FILES AND A DATABASE DUMP BEFORE !!!
    # rm -Rf "${BAM_FOLDER_REL}"
    # mkdir ${BAM_FOLDER_REL}

    # HTTPDUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`

    # if hash chmod 2>/dev/null; then
    #     chmod +a "$HTTPDUSER allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs
    #     chmod +a "`whoami` allow delete,write,append,file_inherit,directory_inherit" app/cache app/logs
    # else
    #     setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX ${FILES_FOLDER_REL}
    #     setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX ${FILES_FOLDER_REL}
    # fi

    rsync -e "ssh -o StrictHostKeyChecking=no" -v --perms --checksum --omit-dir-times --compress --recursive --links --executability -D --delete-after --exclude-from ${BASEDIR}/rsync_data_exclude.txt "${LEAD_USER}@${LEAD_DOMAIN}:${LEAD_ROOT}${BAM_FOLDER}/" "${BAM_FOLDER_REL}/"

    BACKUP_FILE_NAME=$(find ${BASEDIR}/..${BAM_FOLDER} -name "*.gz" | sort -r | head -1 | cut -d '/' -f10)
    BACKUP_FILE=${BAM_FOLDER_REL}/${BACKUP_FILE_NAME}

    echo "try to restore: ${BACKUP_FILE_NAME}"

    cd ${DRUPAL_ROOT} && drush bam-restore db manual ${BACKUP_FILE_NAME} -y
else
    echo "File-sync aborted by user."
fi