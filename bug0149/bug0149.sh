set -x

BUG_NUM=0149
STAGE_DIR=/opt/patches/bug$BUG_NUM/patch
BACKUP_DIR=/opt/patches/bug$BUG_NUM/backup

# back it up
mkdir -p $BACKUP_DIR/etc/config
cp /etc/config/dhcp $BACKUP_DIR/etc/config
cp /etc/config/tunneldigger $BACKUP_DIR/etc/config

# copy backup to staging
rm -r $STAGE_DIR
cp -r $BACKUP_DIR $STAGE_DIR

# edit staged files

# delete line in /etc/config/dhcp
uci -c $STAGE_DIR/etc/config delete dhcp.@dnsmasq[0].server
uci -c $STAGE_DIR/etc/config commit dhcp

# delete old ips, add new exitnode hostnames to /etc/config/tunneldigger
uci -c $STAGE_DIR/etc/config delete tunneldigger.main.address
uci -c $STAGE_DIR/etc/config add_list tunneldigger.main.address='exit.sudomesh.org:8942'
uci -c $STAGE_DIR/etc/config add_list tunneldigger.main.address='exit.sudomesh.org:443'
uci -c $STAGE_DIR/etc/config add_list tunneldigger.main.address='exit1.sudomesh.org:8942'
uci -c $STAGE_DIR/etc/config add_list tunneldigger.main.address='exit1.sudomesh.org:443'
uci -c $STAGE_DIR/etc/config add_list tunneldigger.main.address='exit2.sudomesh.org:8942'
uci -c $STAGE_DIR/etc/config add_list tunneldigger.main.address='exit2.sudomesh.org:443'
uci -c $STAGE_DIR/etc/config add_list tunneldigger.main.address='107.170.219.5:8942'
uci -c $STAGE_DIR/etc/config add_list tunneldigger.main.address='107.170.219.5:443'
uci -c $STAGE_DIR/etc/config commit tunneldigger

# copy from staging to /etc/config
cp -r $STAGE_DIR/* /

# log that it happened
echo -e "$(date -Iseconds)\tbug$BUG_NUM\tapplied" >> /opt/patches/patch.log
