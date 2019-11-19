#!/usr/bin/env python3

from functools import partial
from scapy.all import *

import pdb, sys, os
import numpy as np
import pickle as pkl

max_iter = 1000
max_message_bytes = 256
max_jump = 1

ids_per_iter = max_message_bytes * max_jump * 8 * 2 #for dummy
ids_total = ids_per_iter * max_iter

pcap_folder = 'pcap/'
carrier_file = 'carrier2.pkl'

def main():
    all_ids = []

    pcap_files = [pcap_folder + pf for pf in os.listdir(pcap_folder) if pf.endswith('.pcap')]
    stop_filter = lambda _: len(all_ids) == ids_total
    
    sniff(offline=pcap_files, 
         prn=partial(get_tcp_urg, all_ids), 
         store=0, 
         stop_filter= stop_filter)
    
    assert stop_filter(None), '%d ids available, %d needed' % (len(all_ids), ids_total)


    id_iter = [all_ids[i*ids_per_iter:(i+1)*ids_per_iter] for i in range(max_iter)]
    np.random.shuffle(id_iter)
    real_id_iter = [a[:len(a) // 2] for a in id_iter]
    dummy_id_iter = [a[len(a) // 2:] for a in id_iter]

    assert(all([len(a) == ids_per_iter / 2 for a in real_id_iter + dummy_id_iter]))

    with open(carrier_file, 'wb') as f:
       pkl.dump((real_id_iter, dummy_id_iter), f)



    # real_ids = all_ids[:len(all_ids) // 2]
    # dummy_ids = all_ids[len(all_ids) // 2:]
    # ids_needed_cum = np.cumsum(ids_needed)
    # real_id_iter = [real_ids[b:e] for b,e in zip([0] + list(ids_needed_cum), list(ids_needed_cum))]
    # dummy_id_iter = [dummy_ids[b:e] for b,e in zip([0] + list(ids_needed_cum), list(ids_needed_cum))]

    # real_ids = all_ids[len(all_ids) // 2:]
    # dummy_ids = all_ids[:len(all_ids) // 2]

    # ids_needed_cum = np.cumsum(ids_needed) * 2
    # id_iter = [all_ids[b:e] for b,e in zip([0] + list(ids_needed_cum), list(ids_needed_cum))]
    # np.random.shuffle(id_iter)
    # real_id_iter = [a[:len(a) // 2] for a in id_iter]
    # dummy_id_iter = [a[len(a) // 2:] for a in id_iter]

    # real_id_iter = [all_ids[i*nbits:(i+1)*nbits] for i in range(args.iterations)]
    # dummy_id_iter = [all_ids[i*nbits:(i+1)*nbits] for i in range(args.iterations, 2*args.iterations)]
    
    # np.random.shuffle(real_id_iter)
    # np.random.shuffle(dummy_id_iter)

def get_ip_id(ids, pkt):
    if IP in pkt:
        ids.append(pkt['IP'].fields['id'])

def get_ip_ttl(ids, pkt):
    if IP in pkt:
        ids.append(pkt['IP'].fields['ttl'])

def get_tcp_urg(ids, pkt):
    if TCP in pkt and 'U' in pkt['TCP'].flags:
        ids.append(pkt['TCP'].urgptr)

if __name__ == "__main__":
    main()
