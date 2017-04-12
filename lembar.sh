

#!/bin/sh
#
# z3bra - (c) wtfpl 2014
# Fetch infos on your computer, and print them to stdout every second.

clock() {
        DATETIME=$(date "+%a %b %d, %T")

        echo -n "$DATETIME"
}

battery() {
        BATPERC=$(acpi --battery | cut -d, -f2)   
        echo "$BATPERC   "
}

volume() {
    amixer get Master | sed -n 'N;s/^.*\[\([0-9]\+%\).*$/\1/p'
}

cpuload() {
    LINE=`ps -eo pcpu |grep -vE '^\s*(0.0|%CPU)' |sed -n '1h;$!H;$g;s/\n/ +/gp'`
    bc <<< $LINE
}

network() {
    read lo int1 int2 <<< `ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p'`
    if iwconfig $int1 >/dev/null 2>&1; then
        wifi=$int1
        eth0=$int2
    else
        wifi=$int2
        eth0=$int1
    fi
    ip link show $eth0 | grep 'state UP' >/dev/null && int=$eth0 ||int=$wifi

    #int=eth0

    ping -c 1 8.8.8.8 >/dev/null 2>&1 && 
        echo "$int Connected" || echo "$int Disconnected"
}

# This loop will fill a buffer with our infos, and output it to stdout.
while :; do
    buf="%{l}%{F#C2BEBF}%{B#282828}"
    buf="   ${buf} $(clock) |"
    buf="${buf} $(network) "
    buf="${buf} %{r} CPU: $(cpuload)% |"
    buf="${buf} Volume: $(volume) |"
    buf="${buf} Battery: $(battery)"

    echo $buf
    # use `nowplaying scroll` to get a scrolling output!
    sleep 1 # The HUD will be updated every second
done
