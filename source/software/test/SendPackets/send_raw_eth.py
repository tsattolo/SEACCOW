from scapy.all import *
import zlib

packet = Raw(range(256))
hexdump(packet)
print(hex(zlib.crc32(bytes(packet))))
sendp(packet, iface="eno1")
