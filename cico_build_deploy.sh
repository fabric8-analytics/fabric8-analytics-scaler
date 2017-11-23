#!/bin/bash

set -ex

. cico_setup.sh

make test

build_image

push_image
