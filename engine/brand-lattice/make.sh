#!/bin/zsh
# learner-1 teaser v7: build the renderer
set -e
cd "$(dirname "$0")"
cat lib.swift timeline.swift mind.swift art.swift world.swift scene.swift main.swift > render.swift
swiftc -O render.swift -o render
