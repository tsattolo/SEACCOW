from scapy.all import *
import zlib

packet = Ether()/IP(dst="1.2.3.4")/TCP()/Raw(range(18))
hexdump(packet)
print(hex(zlib.crc32(bytes(packet))))
sendp(packet, iface="eno1")
