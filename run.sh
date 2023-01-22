#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

python_noterm_bare() {
    echo -e "$GREEN[+] Launching python script in background$NC"
    ./noterm_wait.py &
    child_pid=$!
    echo -e "$GREEN[+] PID of python script: $child_pid$NC"
    echo -e "$GREEN[+] Sending SIGTERM to PID $child_pid$NC"
    kill -s TERM $child_pid
    if ps -p $child_pid > /dev/null
    then
        echo -e "$RED[!] PID $child_pid is still running$NC"
    else
        echo -e "$GREEN[+] PID $child_pid is not running$NC"
    fi
}

python_term_bare() {
    echo -e "$GREEN[+] Launching python script in background$NC"
    ./term_wait.py > ./term_wait.log &
    sleep 1
    child_pid=$!
    echo -e "$GREEN[+] PID of python script: $child_pid$NC"
    echo -e "$GREEN[+] Sending SIGTERM to PID $child_pid$NC"
    kill -s TERM $child_pid
    sleep 1
    if ps -p $child_pid > /dev/null
    then
        echo -e "$RED[!] PID $child_pid is still running$NC"
    else
        echo -e "$GREEN[+] PID $child_pid is not running$NC"
    fi
    echo -e "$GREEN[+] PID $child_pid process stdout:$NC"
    echo ""
    cat ./term_wait.log
    rm ./term_wait.log
}

python_noterm_docker_noinit() {
    echo -e "$GREEN[+] Launching python script in Docker container$NC"
    docker run -d -v $PWD/noterm_wait.py:/noterm_wait.py --rm --name python_noinit python:3.11.1-alpine python3 /noterm_wait.py
    sleep 1
    echo -e "$GREEN[+] ps command output in container:$NC"
    echo ""
    docker exec -it python_noinit ps -ef
    echo -e "$GREEN[+] Stopping docker container and timing it. If it takes more then 10 seconds, it means"
    echo -e "    that docker killing the process.$NC"
    time docker stop python_noinit
}

python_term_docker_noinit() {
    echo -e "$GREEN[+] Launching python script in Docker container$NC"
    docker run -d -v $PWD/term_wait.py:/term_wait.py --name python_noinit python:3.11.1-alpine python3 /term_wait.py
    sleep 1
    echo -e "$GREEN[+] ps command output in container:$NC"
    echo ""
    docker exec -it python_noinit ps -ef
    echo -e "$GREEN[+] Stopping docker container and timing it. If it takes more then 10 seconds, it means"
    echo -e "    that docker killing the process.$NC"
    time docker stop python_noinit > /dev/null
    echo -e "$GREEN[+] Container logs:$NC"
    echo ""
    docker logs python_noinit
    docker rm python_noinit > /dev/null
}

python_noterm_docker_init() {
    echo -e "$GREEN[+] Launching python script in Docker container with init as PID 1$NC"
    docker run -d -v $PWD/noterm_wait.py:/noterm_wait.py --rm --init --name python_init python:3.11.1-alpine python3 /noterm_wait.py
    sleep 1
    echo -e "$GREEN[+] ps command output in container:$NC"
    echo ""
    docker exec -it python_init ps -ef
    echo -e "$GREEN[+] Stopping docker container and timing it. If it takes more then 10 seconds, it means"
    echo -e "    that docker killing the process.$NC"
    time docker stop python_init
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
    "python_term_docker_noinit" )
        python_term_docker_noinit;
        ;;
    "python_noterm_docker_init" )
        python_noterm_docker_init;
        ;;
esac
