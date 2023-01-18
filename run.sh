#!/bin/bash

python_noterm_bare() {
    echo "[+] Launching python script in background"
    ./noterm_wait.py &
    child_pid=$!
    echo "[+] PID of python script: $child_pid"
    echo "[+] Sending SIGTERM to PID $child_pid"
    kill -s TERM $child_pid
    if ps -p $child_pid > /dev/null
    then
        echo "[!] PID $child_pid is still running"
    else
        echo "[!] PID $child_pid is not running"
    fi
}

python_term_bare() {
    echo "[+] Launching python script in background"
    ./term_wait.py > ./term_wait.log &
    sleep 1
    child_pid=$!
    echo "[+] PID of python script: $child_pid"
    echo "[+] Sending SIGTERM to PID $child_pid"
    kill -s TERM $child_pid
    if ps -p $child_pid > /dev/null
    then
        echo "[!] PID $child_pid is still running"
    else
        echo "[!] PID $child_pid is not running"
    fi
    echo ""
    echo "PID $child_pid process stdout:"
    echo ""
    cat ./term_wait.log
    rm ./term_wait.log
}

case $1 in
    "python_noterm_bare" )
        python_noterm_bare;
        ;;
    "python_term_bare" )
        python_term_bare;
        ;;
esac
