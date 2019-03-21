BUG_NUM=0149
STAGE_DIR=/opt/patches/bug$BUG_NUM/patch
BACKUP_DIR=/opt/patches/bug$BUG_NUM/backup

cp -r $BACKUP_DIR/* /
echo -e "$(date -Iseconds)\tbug$BUG_NUM\treverted" >> /opt/patches/patch.log
