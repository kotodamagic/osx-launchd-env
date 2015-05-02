/usr/bin/env | while read line; do
    k=`echo $line | sed -Ee 's/^([^=]*)=.*/\1/'`
    v=`echo $line | sed -Ee 's/^[^=]*=(.*)/\1/'`
    if [ -n "$k" -a -n "$v" ]; then
        /bin/launchctl setenv "$k" "$v"
    fi
done
