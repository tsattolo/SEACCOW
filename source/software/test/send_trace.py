#!/usr/bin/env python3

from scapy.all import *
import pdb, sys
import pickle as pkl

def main():
    with open(sys.argv[1], 'rb') as f:
        traces = pkl.load(f)
    nbits = int(sys.argv[2])

    pl = []
    for t in traces[nbits]:
        for v in t:
            packet = Ether()/IP(dst="1.2.3.4")/TCP()/Raw('This is a TCP payload')
            packet.id = v
            pl.append(packet)    
    # pdb.set_trace()
    sendp(pl, iface='eno1')

    

if __name__ == "__main__":
    main()
