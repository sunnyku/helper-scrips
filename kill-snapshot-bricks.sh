#!/usr/bin/env bash

# this function will kill all the active snap brick process

kill_all_snap_bricks()
{
	pidfiles=$(find /var/run/gluster/snaps/ -name '*.pid')
	for pidfile in ${pidfiles};
	do
		pid=$(cat ${pidfile});
		echo "sending SIGTERM to pid: ${pid}";
		kill -SIGTERM ${pid};
	done

}

# this funtion will deactivate all snaps

deactivate_snaps()
{
	snaps=$(gluster snap list)
	for snap in ${snaps};
	do
		if [[ $(gluster snap deactivate $snap --mode=script 2> /dev/null |
			grep -c "Snap deactivated successfully") -gt 0 ]]
		then
			echo "snpashot $snap deactivated";
		fi
	done
}


#this function will unmount snapshot

unmount_snap()
{
	mount_devs=$(mount | grep run/gluster/snaps| awk '{print $1}')
	for mount_dev in ${mount_devs};
	do
		if [[ $(umount $mount_dev 2> /dev/null |
                        grep -c $mount_dev) -eq 0 ]]
                then
                        echo "Unmounted : $mount_dev";
                fi
	done
}

caller()
{
	kill_all_snap_bricks
	unmount_snap
	deactivate_snaps
}

caller


