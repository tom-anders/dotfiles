#!/usr/bin/env bash

git ls-files --recurse-submodules | ~/.cargo/bin/proximity-sort $1
