#!/bin/zsh
# local v0.0.9 launch film: build the renderer
set -e
cd "$(dirname "$0")"
cat lib.swift timeline.swift film.swift main.swift > render.swift
swiftc -O render.swift -o render
