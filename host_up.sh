#!/bin/bash

# Check for the correct number of command-line arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <start_ip> <end_ip>"
    exit 1
fi

start_ip="$1"
end_ip="$2"

# Loop through the IP range and ping each IP
for ((i=1; i<=10; i++)); do
  ip="$start_ip"
  start_ip_last_byte=$(echo $start_ip | cut -d'.' -f4)
  ip_last_byte=$((start_ip_last_byte + i - 1))
  ip=$(echo $start_ip | cut -d'.' -f1-3).$ip_last_byte

  # Ping the IP with a single ICMP packet and wait up to 1 second for a response
  if ping -c1 -W1 "$ip" &> /dev/null; then
    echo "$ip is UP"
  else
    echo "$ip is DOWN"
  fi
done
