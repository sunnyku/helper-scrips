# helper-scrips
Few scripts for just debugging or coming out of some weird scenarios
1.  kill-snapshot-bricks.sh

    Description:
    script to deactivate activated snapshot manully in glusterfs
    This script will deactivate activated snapshot manully in glusterfs.
    There is no delete operation used is this script so this probably will not
    cause data loss.

2. Remove_missing_file.sh
   
   Description:
   [WIP] Do not use it without contecting OWNER. This script removes data!!!! 
   This is a helper script to remove extra file.


3. compare_master_slave.sh

   Description:
   This script comapres master and slave gluster volume and gives 3 output-
    a. du usage of extra files.
    b. loaction of extra files.
    c. gfid of extra files.
   How to use this:
   mount master volume at say /mnt/master
   mount slave volume at say /mnt/slave
   run this script as:
   ./compare_master_slave.sh /mnt/master /mnt/slave
   Limitation:
    If geo-rep is stopped or in history betwwen slave and master it will record all renames as diffrenet files.


