#!/bin/zsh
# forgetting on purpose: build the renderer
set -e
cd "$(dirname "$0")"
cat lib.swift timeline.swift skull.swift art.swift world.swift scene_base.swift scene_film.swift main.swift > render.swift
swiftc -O render.swift -o render
