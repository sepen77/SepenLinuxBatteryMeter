dirname=/sys/class/power_supply/BAT0
battPer=$(expr `cat $dirname/charge_now` \* 100 / `cat $dirname/charge_full`)
battStat=`cat $dirname/status`

# flags
a=false
t=false
s=false

# parses arguments
while [ $# -gt 0 ]
    do
	key="$1"
	
	# display all info	
	case $key in
	-a|--all)
		a=true
		;;
	-t|--status)
		t=true
		;;
	-s|--silent)
		s=true
		;;
	--default)
		DEFAULT=YES
		;;
	*)
		;;
	esac
	
	shift
done

if $a
    then
	s=false
fi

message=""
warning=""
if [ $battPer -lt 20 ]
    then
	warning="====== !!! ====== BATTERY CRITICAL ====== !!! ======\n"

elif [ $battPer -lt 30 ]
    then
	warning="=== ! === BATTERY LOW === ! ===\n"
fi

# display only status if t
if $a
    then
	message="Battery: ${battPer}%%  ...  Status: ${battStat}\n"
elif $t
    then
	message="Status: ${battStat}\n"
else
	message="Battery: ${battPer}%%\n"
fi
	
# display no warnings
if $s
    then
	warning=""
fi

out=""

if [ "$warning" ]
    then
	out="$out""$warning"
fi

out="$out$message"
printf "$out"

