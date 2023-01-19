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

python_noterm_docker_noinit() {
    echo "[+] Launching python script in Docker container"
    docker run -d -v $PWD/noterm_wait.py:/noterm_wait.py --rm --name python_noinit python:3.11.1-alpine python3 /noterm_wait.py
    sleep 1
    echo "[+] ps command output in container:"
    echo ""
    docker exec -it python_noinit ps -ef
    echo "[+] Stopping docker container and timing it. If it takes more then 10 seconds, it means"
    echo "    that docker killing the process."
    time docker stop python_noinit
}

case $1 in
    "python_noterm_bare" )
        python_noterm_bare;
        ;;
    "python_term_bare" )
        python_term_bare;
        ;;
    "python_noterm_docker_noinit" )
        python_noterm_docker_noinit;
        ;;
esac
