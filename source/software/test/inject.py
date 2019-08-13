#!/usr/bin/env python3

from scapy.all import *
import sys
import random
import pdb
import lzma
from functools import partial
import pandas as pd

field_size = 16
xor_rand = True
whole_carrier = True


def main():
    pcap_folder = sys.argv[1]
    message = sys.argv[2]
    iterations = int(sys.argv[3])
    outfile = sys.argv[4]
    
    with open(message, 'rb') as f:
        msg = list(f.read())
    
    bits = [d for c in msg for d in '{0:08b}'.format(c)]
    nbits =  len(bits)


    real_ids = []
    pcap_files = [pcap_folder + pf for pf in os.listdir(pcap_folder) if pf.endswith('.pcap')]

    stop_filter = lambda _: len(real_ids) == iterations*nbits
    
    sniff(offline=pcap_files, 
         prn=partial(get_ip_id, real_ids), 
         store=0, 
         stop_filter= stop_filter)
    
    if not stop_filter:
        new_iterations = len(real_ids) // nbits
        print('Not enough packet for  %i iterations, doing %i instead' % 
                (iterations, new_iterations))
        real_ids = real_ids[:new_iterations*nbits]
        iterations = new_iterations

    real_id_iter = [real_ids[i*nbits:(i+1)*nbits] for i in range(iterations)]


    random.seed(17)

    res_dict = {'comp':[], 'rep':[]}
    for i in range(iterations):
        # pdb.set_trace()
        traces = inject(field_size, real_id_iter[i], bits, xor_rand, whole_carrier)
        res_dict['comp'].append(check_compress(traces))
        res_dict['rep'].append(check_repeat(traces))

    
    df_dict = dict([(k, pd.DataFrame(v).T) for k, v in res_dict.items()])

    df = pd.concat(df_dict).T

    df.to_pickle(outfile)






    
def inject(field_size, carrier, message_bits, xor_rand=False, whole_carrier=False):
    # bls = []
    traces = []
    for bp in range(field_size + 1):
        
        pktm = get_pktm(message_bits, bp) if not bp == 0 else []
        
        if whole_carrier or bp == 0:
            pktm.extend([0] * (len(carrier) - len(pktm)))
        
        mask = ~((1 << bp) - 1)
        xored = random.getrandbits(bp) if xor_rand and bp > 0 else 0

        trace  = [((b & mask) | (m ^ xored)).to_bytes(2, byteorder='big') for b, m in zip(carrier, pktm)]
        traces.append(trace)
        # pdb.set_trace()

    return traces

    
def check_compress(traces):
    byte_traces = [b''.join(tr) for tr in traces]
    return [len(lzma.compress(btr)) / len(btr) for btr in byte_traces]

def check_repeat(traces):
    return [len(set(tr)) / len(tr) for tr in traces]

    # res.sort()
    # for r in res:
    #     print('%s: %f, repeats: %d' % (r[1], r[0], r[2]))

            








def get_pktm(bits, bits_per): 
    pktb = [bits[i:i+bits_per] for i in range(0, len(bits), bits_per)]
    return [int(''.join(m), 2) for m in pktb]
    

def get_ip_id(ids, pkt):
    if IP in pkt:
        ids.append(pkt['IP'].fields['id'])


    
    

    
    


if __name__ == "__main__":
    main()
