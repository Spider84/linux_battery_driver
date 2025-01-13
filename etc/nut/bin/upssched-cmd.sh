#!/bin/sh
MSG1="on battery. The UPS has been on battery for a while, logout right now!"
MSG2="forced shutdown. UPS on battery too long, forced shutdown!"
MSG3="forced shutdown. UPS battery to low, forced shutdown!"
UPS_NAME=apc1500

case $1 in
    onbatt1)
        logger -t upssched-cmd $MSG1
        wall $MSG1
        echo 'charging = 0' | /usr/bin/sudo /usr/bin/tee /dev/anyon_e_battery
        ;;
    earlyshutdown)
        logger -t upssched-cmd $MSG2
        /bin/upscmd -u upsmon -p upsmonpassword $UPS_NAME shutdown.return
        /sbin/upsmon -c fsd
        ;;
    lowbatt)
        logger -t upssched-cmd $MSG3
        ;;
    ups-back-on-line)
        echo 'charging = 1' | /usr/bin/sudo /usr/bin/tee /dev/anyon_e_battery
        ;;
    *)
        logger -t upssched-cmd "ERROR!! $0 doesn't support $1"
        ;;
esac