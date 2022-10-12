#!/bin/bash

################################################################
##
##   Public Folder To Amazon S3
##   Written By: paulojrs.ti@gmail.com
##   https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html
##
##   $crontab -e
##   Weekly website backup, at 01:30 on Sunday
##   30 1 * * 0 /home/paulojacinto/Documents/enesolucoes/portal-voluntariado/pasta-teste/bkp-completo.sh > /dev/null 2>&1
################################################################

#NOW=$(date +"%Y-%m-%d")
NOW=$(date +"%Y-%m-%d__%H-%M-%S-%Z")
NOW_TIME=$(date +"%Y-%m-%d %T %p")
NOW_MONTH=$(date +"%Y-%m")

BACKUP_DIR="/home/paulojacinto/Documents/xxx/$NOW_MONTH"
BACKUP_FILENAME="public-folder-$NOW.tar.gz"
BACKUP_FULL_PATH="$BACKUP_DIR/$BACKUP_FILENAME"

AMAZON_S3_BUCKET="s3://portal-voluntariado/bkp-public/$NOW_MONTH/"
AMAZON_S3_BIN="/bin/aws"
AWS_PROFILE="portalvoluntariadoprd"

# put the files and folder path here for backup
# CONF_FOLDERS_TO_BACKUP=("/etc/nginx/nginx.conf" "/etc/nginx/conf.d" "/path.to/file" "/path.to/folder")
  FOLDERS_TO_BACKUP=("/home/paulojacinto/Documents/xxx/portal-voluntariado/pasta-teste/")

#################################################################

mkdir -p ${BACKUP_DIR}

backup_files(){
        tar -czf ${BACKUP_DIR}/${BACKUP_FILENAME} ${FOLDERS_TO_BACKUP[@]}
}

upload_s3(){
        ${AMAZON_S3_BIN} s3 cp ${BACKUP_FULL_PATH} ${AMAZON_S3_BUCKET} --profile ${AWS_PROFILE}
}

backup_files
upload_s3

# this is optional, we use mailgun to send email for the status update
#if [ $? -eq 0 ]; then
        # if success, send out an email
 #       curl -s --user "api:key..." \
  #              https://api.mailgun.net/v3/mg.mkyong.com/messages \
   #             -F from="backup job <backup@mkyong.com>" \
    #            -F to=paulojrs.ti@gmail.com \
     #           -F subject="Backup Successful (Site) - $NOW" \
      #          -F text="File $BACKUP_FULL_PATH is backup to $AMAZON_S3_BUCKET, time:$NOW_TIME"
#else
        # if failed, send out an email
 #       curl -s --user "api:key..." \
  #              https://api.mailgun.net/v3/mg.mkyong.com/messages \
   #             -F from="backup job <backup@yourdomain.com>" \
    #            -F to=paulojrs.ti@gmail.com \
     #           -F subject="Backup Failed! (Site) - $NOW" \
      #          -F text="Unable to backup!? Please check the server log!"
#fi;

#if [ $? -eq 0 ]; then
#  echo "Backup is done! ${NOW_TIME}" | mail -s "Backup Successful (Site) - ${NOW}" -r cron admin@mkyong.com
#else
#  echo "Backup is failed! ${NOW_TIME}" | mail -s "Backup Failed (Site) ${NOW}" -r cron admin@mkyong.com
#fi;
