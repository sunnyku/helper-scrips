#!/usr/bin/bash

E_BADARGS=65


file_diff="`basename $0`_files_from_diff";
file_du="`basename $0`_du_file";
file_gfid="`basename $0`_gfid_form_diff";

rm -f $file_diff;
rm -f $file_du;
rm -rf $file_gfid;

#diff command to comapere

diff -qr $1 $2 | cut -d" " -f3,4 |  sed 's/: /\//g'> $file_diff


create_gfid_and_path_file()
{
while read line
do
           name=$(echo "$line" |awk '{print $NF}');
           du $name>>$file_du;
           file_to_cmp=$(getfattr -n glusterfs.gfid.string "$name"  --only-values  2>/dev/null)
           echo "$file_to_cmp" >> $file_gfid

done < $file_diff
}

main ()
{
    if [ $# -ne 2 ]
    then
        echo "Usage: `basename $0` MASTER_MOUNT_DIR SLAVE_MNT_DIR";
        exit $E_BADARGS;
    fi

    create_gfid_and_path_file;
}

main "$@";


