#!/usr/sbin/nft -f

# TODO: Review, just an internet sample.
flush ruleset

# Interfaces and Networks
define wan = eth0
define lan = eth0

table ip filter {
  chain input {
    type filter hook input priority 0; policy drop;

    # Drop All Martians
    meta iif $wan ip saddr { 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12 } log counter drop

    # Drop and Log Invalid Connections
    ct state invalid log counter drop

    # Allow All Loopback Traffic
    meta iif lo ct state new accept

    # Allow LAN Inbound Traffic
    meta iif $lan ct state new accept

    # Respond to ICMP Echo Requests Only
    icmp type echo-request accept

    # established/related connections
    ct state established,related accept
  }

  chain forward {
    type filter hook forward priority 0; policy drop;

    # Allow LAN Traffic out the WAN Interface
    meta iif $lan meta oif $wan accept

    # Allow Related Traffic
    meta iif $wan meta oif $lan ct state established,related accept
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

