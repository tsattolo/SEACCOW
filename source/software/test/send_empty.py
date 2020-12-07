from scapy.all import *

packet = Raw([25])
hexdump(packet)
sendp(packet, iface="eno1")
