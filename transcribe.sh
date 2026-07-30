#!/usr/bin/env bash
set -euo pipefail

WHISPER="$HOME/software/whisper.cpp/build/bin/whisper-cli"
MODEL="$HOME/software/whisper.cpp/models/ggml-base.en.bin"
WIDTH=80

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 video1.mp4 video2.mp4 ..."
    exit 1
fi

for video in "$@"; do
    if [ ! -f "$video" ]; then
        echo "Skipping missing file: $video"
        continue
    fi

    output="${video%.*}.txt"

    echo "Transcribing: $video -> $output"

    tmp=$(mktemp --suffix=.wav)
    rm -f "$tmp"
    ffmpeg -nostdin -loglevel error \
        -i "$video" \
        -f wav \
        -acodec pcm_s16le \
        -ar 16000 \
        -ac 1 \
        "$tmp"
    "$WHISPER" \
        -m "$MODEL" \
        -f "$tmp" \
        --no-timestamps \
        2>/dev/null \
    | fold -s -w "$WIDTH" > "$output"
    rm -f "$tmp"

    echo "Done: $output"
done
