from scapy.all import *
import zlib

packet = Raw([0xFF]*256)
hexdump(packet)
print(hex(zlib.crc32(bytes(range(256)))))
sendp(packet, iface="eno1")
