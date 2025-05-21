#!/usr/sbin/nft -f

flush ruleset

# Interfaces and Networks
define wan = eth0
define ssh_port = 22000

table ip filter {
  chain input {
    type filter hook input priority 0; policy drop;

    # Drop All Martians
    meta iif $wan ip saddr { 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12 } log counter drop

    # Drop and Log Invalid Connections
    ct state invalid log counter drop

    # Allow All Loopback Traffic
    meta iif lo ct state new accept

    # Allow SSH
    tcp dport $ssh_port ct state new accept

    # Respond to ICMP Echo Requests Only
    icmp type echo-request accept

    # established/related connections
    ct state established,related accept
  }

  chain forward {
    type filter hook forward priority 0; policy drop;

    # No forwarding needed for a dedicated SFTP server
  }

  chain output {
    type filter hook output priority 0; policy accept;
  }
}

# The first packet in each flow will hit this table; none others will
table ip nat {
  chain prerouting {
    type nat hook prerouting priority -150;
  }

  chain postrouting {
    type nat hook postrouting priority -150;
    oif $wan masquerade persistent
  }
}

