iptables -t nat -I PREROUTING -p tcp -d 172.16.5.50 --dport 80 -j DNAT --to 10.0.3.100:80
iptables -A FORWARD -p tcp -d 10.0.3.100 --dport 80 -j ACCEPT

