#!/bin/bash
# POS Query Update
# Update stores with files to allow the
# ability to query store DBs from corporate.

ROOT=/path/to/template/files #root folder of script
STOREDIR=/opt/informix/etc
INPUT=$ROOT/input_files/stores.unl #path to input file

for i in $(cat $INPUT); do
STORE=$i
VERSION_CHECK=$(sudo ssh root@z$STORE "cd /opt/informix/; . ./getset; onstat - | grep -o 'Version 11'")

#Check Version of Informix, then copy corresponding templates to be edited
if [ "$VERSION_CHECK" == "Version 11" ]; then
cp $ROOT/dist_v11/* $ROOT/temp
cd $ROOT/temp

else

cp $ROOT/dist_v10/* $ROOT/temp
cd $ROOT/temp
fi

# Edit template files with store-specific info
sed -i "s/XXX/$STORE/g" *
mv onconfig.ol_zumiez_XXX onconfig.ol_zumiez_$STORE

# Backup files on store system
sudo ssh root@z$STORE << EOF
mv $STOREDIR/onconfig.ol_zumiez_$STORE $STOREDIR/onconfig.ol_zumiez_$STORE.bak
mv $STOREDIR/sqlhosts $STOREDIR/sqlhosts.bak
EOF

# Transfer updated files to store system
sudo scp $ROOT/temp/* root@z$STORE:/opt/informix/etc

# Check updated files on store system
echo $STORE >> $ROOT/check.log
sudo ssh root@z$STORE "cat $STOREDIR/onconfig.ol_zumiez_$STORE $STOREDIR/sqlhosts | grep $STORE" 2>/dev/null >> $ROOT/check.log
echo "" >> $ROOT/check.log

sudo ssh root@z$STORE <<EOF
zap r001
zap r002
zap r003
chown informix:informix /opt/informix/etc/onconfig*
service online restart
EOF

# Remove edited files
rm -f $ROOT/temp/*

done

