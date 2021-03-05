#!/usr/bin/env bash

keyboard_layout=${keyboard_layout:="us"}

content=$(cat <<EOF
XKBMODEL="pc105"
XKBLAYOUT="$keyboard_layout"
XKBVARIANT=""
XKBOPTIONS="grp:alt_shift_toggle"

BACKSPACE="guess"
EOF
)

echo "$content" | sudo tee /etc/default/keyboard
