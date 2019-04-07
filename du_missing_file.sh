#!/bin/sh

E_BADARGS=65


gfid_to_path_and_du ()
{
    brick_dir=$1;
    gfid_file=$(readlink -e $2);

    current_dir=$(pwd);
    cd $brick_dir;

    while read gfid
    do
        to_search=`echo .glusterfs/${gfid:0:2}"/"${gfid:2:2}"/"$gfid`;
        name=$(find . -samefile $to_search | grep -v $to_search);
        #echo "$name"
        name=$(echo $name | cut -c 2-)
        #cd $1;
        if [ ! -z "$name" ]; then
             #echo "\$name is empty
             du $brick_dir$name>>$current_dir/$file_du;
        fi
    done < $gfid_file;

    cd $current_dir;
} 2>/dev/null



main ()
{
    if [ $# -ne 3 ]
    then
        echo "Usage: `basename $0` BRICK_DIR GFID_FILE OUTPUT_FILE";
        exit $E_BADARGS;
    fi

    file_du="`basename $3`";
    echo "$file_du Will be created which will contain du output"

    gfid_to_path_and_du $1 $2;
}

main "$@";

