#Format disk
sudo mkfs.ext4 -F -E lazy_itable_init=0,\
lazy_journal_init=0,discard \
/dev/disk/by-id/google-minecraft-disk

# Mount the disk
sudo mount -o discard,defaults /dev/disk/by-id/google-minecraft-disk /home/minecraft

# run minecraft on a screen
sudo screen -S mcs java -Xmx1024M -Xms1024M -jar server.jar nogui