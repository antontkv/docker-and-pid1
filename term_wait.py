#!/usr/bin/env python3

import signal
from types import FrameType
from time import sleep

def wait_forever():
    while True:
        sleep(1)

def handler(signum: int, frame: FrameType):
    print(f"Received SIGTERM. Exiting.")
    exit(0)

signal.signal(signal.SIGTERM, handler)

if __name__ == "__main__":
    print("Started process.")
    wait_forever()
