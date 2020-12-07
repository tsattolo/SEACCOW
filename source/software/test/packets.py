#!/usr/bin/env python3

from scapy.all import *
import pdb, sys

def main():
    tofile = '-f' in sys.argv
    norep =  '-n' in sys.argv
    ofilename = 'packets.dat'
    pl = rdpcap('http.pcap')[:32]

    with open(ofilename, 'a') as f:
        for j in range(10):
            ids = [5] * len(pl) if j == 4 and not norep else range(len(pl))
            for p, i in zip(pl, ids):
                if IP in p:
                    p.id = i
                    # p[IP].remove_payload()

                if tofile:
                    b= b'\x00\x00' + bytes(p) # Add start of frame delimiter
                    lines = [int.from_bytes(b[i:i+4], byteorder='big') for i in range(0,len(p),4)]
                    for i, l in enumerate(lines):
                        f.write('%x %x %8.8x\n' % (i == 0, i == len(lines) - 1, l))
            if not tofile:
                sendp(pl, verbose=0)

if __name__ == "__main__":
    main()
