#!/usr/bin/env python3

import signal
import uuid
from time import sleep
from types import FrameType


def wait_forever():
    while True:
        sleep(1)

def handler(signum: int, frame: FrameType):
    print(f"[{uuid.uuid4().hex}] Received SIGTERM. Exiting.")
    exit(0)

signal.signal(signal.SIGTERM, handler)

if __name__ == "__main__":
    print("Started process.", flush=True)
    wait_forever()
