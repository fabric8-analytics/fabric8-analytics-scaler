#!/bin/bash

set -ex

check_python_version() {
    python3 tools/check_python_version.py 3 6
}

check_python_version

python3 -m doctest sqs_status.py
