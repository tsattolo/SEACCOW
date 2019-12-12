#!/usr/bin/env python3

from scapy.all import *
import pdb

def main():
    ofilename = 'packets.dat'
    pl = rdpcap('http.pcap')
    ids = [5] * len(pl)

    with open(ofilename, 'w') as f:
        for p, i in zip(pl, ids):
            if IP in p:
                p['IP'].fields['id'] = i
            b= bytes(p)
            lines = [int.from_bytes(b[i:i+4], byteorder='big') for i in range(0,len(p),4)]
            for i, l in enumerate(lines):
                f.write('%x %x %x\n' % (i == 0, i == len(lines) - 1, l))

if __name__ == "__main__":
    main()
