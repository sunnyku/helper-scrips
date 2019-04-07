#!/bin/sh

E_BADARGS=65


#rm -rf gfid_from_diff
#diff -qr $1 $2 | cut -d" " -f3,4|  sed 's/: /\//g' > diff_file

compare_diff_gfid ()
{
	echo "$1--$2"
	while read line
	    do
	        name=$(echo "$line" |awk '{print $NF}')

    		#echo "$name"
    		file_to_cmp=$(getfattr -n glusterfs.gfid.string "$name"  --only-values  2>/dev/null)
    		echo "$file_to_cmp" >> gfid_form_diff
    		#done < diff_file

    		while IFS='' read -r f_1 || [[ -n "$f_1" ]]
        	    do

		        if [[ $f_1 == $file_to_cmp ]]
            	            then
                    	    echo "Deleting file $name"
                            #convert gfid to path
                        fi
                done < $1

	done < $2
}

gfid_to_path ()
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
	cd $1;
	if [ ! -z "$name" ]; then
	     #echo "\$name is empty
             stat $name;
	     retval=$?
             if [ $retval -eq 0 ]; then
                  echo "Sucess";
                  rm -f $name;
             fi
        fi
    done < $gfid_file;

    cd $current_dir;
}



main ()
{
    if [ $# -ne 2 ]
    then
        echo "Usage: `basename $0` BRICK_DIR GFID_FILE";
        exit $E_BADARGS;
    fi

    gfid_to_path $1 $2;
    #compare_diff_gfid $2 $3
}

main "$@";

