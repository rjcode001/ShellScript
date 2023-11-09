import subprocess
import re
from collections import Counter
import time

def get_attacker_ips(log_file):
    with open(log_file, 'r') as file:
        log_content = file.read()

    # Extract IPs using a simple regex, adjust as needed
    ip_pattern = re.compile(r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b')
    attackers = re.findall(ip_pattern, log_content)
    return attackers

def block_ip(ip):
    subprocess.run(['iptables', '-A', 'INPUT', '-s', ip, '-j', 'DROP'])

def log_attackers(attackers, log_file):
    with open(log_file, 'a') as file:
        timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
        for ip in attackers:
            file.write(f'{timestamp} - Attacker IP: {ip}\n')

def main():
    log_file = 'attack_log.txt'
    threshold = 10  # Adjust as needed

    while True:
        time.sleep(60)  # Adjust the frequency of checks

        # Check logs for potential attackers
        attackers = get_attacker_ips(log_file)
        if not attackers:
            continue

        # Count occurrences of each IP
        ip_counter = Counter(attackers)

        # Identify potential attackers based on threshold
        potential_attackers = [ip for ip, count in ip_counter.items() if count >= threshold]

        # Block and log potential attackers
        for attacker in potential_attackers:
            block_ip(attacker)

        log_attackers(potential_attackers, log_file)

if __name__ == "__main__":
    main()
