set -Ux DISPLAY (ip route | awk '/default/ {print $3}'):0
