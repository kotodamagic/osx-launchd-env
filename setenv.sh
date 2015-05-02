contains() {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

basedir=$(cd $(dirname $0) && pwd)
echo $basedir

# read whitelist
if [ -f $basedir/conf/whitelist ]; then
    whitelist=($(IFS='\n'; cat "$basedir/conf/whitelist"))
fi

# read blacklist
if [ -f $basedir/conf/blacklist ]; then
    blacklist=($(IFS='\n'; cat "$basedir/conf/blacklist"))
fi

echo "[$(date +%Y/%m/%d-%H:%M:%S)] Start setting environment variables." >> $basedir/log/setenv.log

# get environment variables
/usr/bin/env | while read line; do
    k=`echo $line | sed -Ee 's/^([^=]*)=.*/\1/'`
    v=`echo $line | sed -Ee 's/^[^=]*=(.*)/\1/'`

    if [ -n "$k" -a -n "$v" ]; then
        # When key and value is not empty

        if [ ${#whitelist[@]} -eq 0 ] || contains "$k" "${whitelist[@]}"; then
            # and whitelist does not exist or
            #     the key is contained in whitelist.

            if [ ${#blacklist[@]} -eq 0 ] || ! contains "$k" "${blacklist[@]}"; then
                # and blacklist does not exist or
                #     the key is not contained in blacklist.

                # define the variable.
                /bin/launchctl setenv "$k" "$v"
                echo "defined $k >> $v" >> $basedir/log/setenv.log
            fi
        fi
    fi
done

echo "[$(date +%Y/%m/%d-%H:%M:%S)] End setting environment variables." >> $basedir/log/setenv.log
