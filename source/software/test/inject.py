#!/usr/bin/env python3

from scapy.all import *
import sys
import random
import pdb
import lzma
from functools import partial
import pandas as pd
import numpy as np
import argparse

from scipy.stats import entropy

field_size = 16


tests = ['comp', 'rep', 'brep', 'ent', 'cov']

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--pcap_folder')
    parser.add_argument('-m', '--message')
    parser.add_argument('-i', '--iterations', type=int)
    parser.add_argument('-o', '--output')
    parser.add_argument('--xor_rand', action='store_true')
    parser.add_argument('--whole_carrier', action='store_true')

    args = parser.parse_args()

    with open(args.message, 'rb') as f:
        msg = list(f.read())
    
    bits = [d for c in msg for d in '{0:08b}'.format(c)]
    nbits =  len(bits)


    real_ids = []
    pcap_files = [args.pcap_folder + pf for pf in os.listdir(args.pcap_folder) if pf.endswith('.pcap')]

    stop_filter = lambda _: len(real_ids) == args.iterations*nbits
    
    sniff(offline=pcap_files, 
         prn=partial(get_ip_id, real_ids), 
         store=0, 
         stop_filter= stop_filter)
    
    if not stop_filter:
        new_iterations = len(real_ids) // nbits
        print('Not enough packet for  %i args.iterations, doing %i instead' % 
                (args.iterations, new_iterations))
        real_ids = real_ids[:new_iterations*nbits]
        args.iterations = new_iterations

    real_id_iter = [real_ids[i*nbits:(i+1)*nbits] for i in range(args.iterations)]


    random.seed(17)

    res_dict = {t:[] for t in tests}
    for i in range(args.iterations):
        # pdb.set_trace()
        traces = inject(field_size, real_id_iter[i], bits, args.xor_rand, args.whole_carrier)
        res_dict['comp'].append(check_compress(traces))
        res_dict['rep'].append(check_repeat(traces))
        res_dict['brep'].append(check_byte_repeat(traces))
        res_dict['ent'].append(check_entropy(traces))
        res_dict['cov'].append(check_covar(traces))

    
    df_dict = dict([(k, pd.DataFrame(v).T) for k, v in res_dict.items()])

    df = pd.concat(df_dict).T

    df.to_pickle(args.output)






    
def inject(field_size, carrier, message_bits, xor_rand=False, whole_carrier=False):
    # bls = []
    traces = []
    for bp in range(field_size + 1):
        
        pktm = get_pktm(message_bits, bp) if not bp == 0 else []
        
        if whole_carrier or bp == 0:
            pktm.extend([0] * (len(carrier) - len(pktm)))
        
        mask = ~((1 << bp) - 1)
        xored = random.getrandbits(bp) if xor_rand and bp > 0 else 0

        # trace  = [((b & mask) | (m ^ xored)).to_bytes(2, byteorder='big') for b, m in zip(carrier, pktm)]
        trace  = [(b & mask) | (m ^ xored) for b, m in zip(carrier, pktm)]
        traces.append(trace)

        # pdb.set_trace()

    return traces

    
def check_compress(traces):
    byte_traces = [b''.join([e.to_bytes(2, byteorder='big') for e in tr]) for tr in traces]
    return [len(lzma.compress(btr)) / len(btr) for btr in byte_traces]

def check_repeat(traces):
    return [len(set(tr)) / len(tr) for tr in traces]

def check_byte_repeat(traces):
    mask = (1 << (field_size // 2)) - 1
    onebyte_traces = [ [e & mask for e in tr] + [e & ~mask for e in tr] for tr in traces] 
    return [len(set(tr)) / len(tr) for tr in onebyte_traces]

def check_entropy(traces):
    dists = [(np.unique(tr, return_counts=True)) for tr in traces]
    return [entropy(d[1], base=2) for d in dists]

def check_covar(traces):
    return [onepass_covar(tr) for tr in traces]

def onepass_covar(tr, d=1):
    
    my = C = 0
    mx = np.mean(tr[:d])
    for i in range(len(tr) - d):
        n = i + 1
        dx = tr[i + d] - mx
        mx += dx / n
        my += (tr[i] - my) / n
        C += dx * (tr[i] - my)

    res = C / (len(tr) - d)
    return res

    # res.sort()
    # for r in res:
    #     print('%s: %f, repeats: %d' % (r[1], r[0], r[2]))

def online_covariance(data1, data2):
    meanx = meany = C = n = 0
    for x, y in zip(data1, data2):
        n += 1
        dx = x - meanx
        meanx += dx / n
        meany += (y - meany) / n
        C += dx * (y - meany)

    return  C / n








def get_pktm(bits, bits_per): 
    pktb = [bits[i:i+bits_per] for i in range(0, len(bits), bits_per)]
    return [int(''.join(m), 2) for m in pktb]
    

def get_ip_id(ids, pkt):
    if IP in pkt:
        ids.append(pkt['IP'].fields['id'])


    
    

    
    


if __name__ == "__main__":
    main()
