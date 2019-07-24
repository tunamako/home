

#!/bin/sh
#
# z3bra - (c) wtfpl 2014
# Fetch infos on your computer, and print them to stdout every second.

clock() {
        date "+%a %b %d, %T"
}

volume() {
    amixer get Master | sed -n 'N;s/^.*\[\([0-9]\+%\).*$/\1/p'
}

cpuload() {
    IDLE=`mpstat 1 1 | grep -A 5 "%idle" | tail -n 1 | awk '{print $12}'`
    bc <<< "100-${IDLE}"
}

memory() {
    free -m | grep Mem | awk '{print 100 * $3/$2}' | grep -o '^[0-9]*\.[0-9]\{2\}'
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

    ping -c 1 8.8.8.8 >/dev/null 2>&1 && 
        echo "Connected" || echo "Disconnected"
}

# This loop will fill a buffer with our infos, and output it to stdout.
Monitors=$(xrandr | grep -o "^.* connected" | sed "s/ connected//")
while :; do
    buf="%{l}%{F#C2BEBF}%{B#282828}"
    buf="${buf} $(clock)  | "
    buf="${buf} $(network) "
    buf="${buf} %{r} MEM: $(memory)%  | "
    buf="${buf} CPU:"

    load=$(cpuload)
    cpuloadlen=`echo -n $load | wc -c`

    if [ $cpuloadlen -eq 5 ]                       
    then
        buf="${buf} ${load}%  "
    fi 

    if [ $cpuloadlen -eq 4 ]
    then
        buf="${buf}   ${load}%  "
    fi

    if [ $cpuloadlen -eq 3 ]
    then
        buf="${buf}   0${load}%  "
    fi 

    #buf="${buf}${load}%  "

    #buf="${buf} Volume: $(volume) |"
    #buf="${buf} Battery: $(battery)"

    tmp=0
    barout=""
    for m in $(echo "$Monitors"); do
	   barout+="%{S${tmp}}$buf"
   	    let tmp=$tmp+1
    done

    echo "$barout"

    # use `nowplaying scroll` to get a scrolling output!
    #sleep 1 # The HUD will be updated every second
done
