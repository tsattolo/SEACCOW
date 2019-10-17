#!/usr/bin/env python3

from scapy.all import *
import sys, os

import random
import pdb
import lzma
from functools import partial
import pandas as pd
import numpy as np
import argparse
import pickle as pkl
import lz78
from itertools import chain
from scipy import stats
from Crypto.Cipher import Salsa20

sys.path.append(os.path.join(sys.path[0],'lz77','src'))
from LZ77 import LZ77Compressor

field_size = 16

lz77 = LZ77Compressor() 

tests = ['comp', 'rep', 'brep', 'ent', 'bent', 'cov', 'lz78', 'lz77', 'ks', 'wcx', 'spr', 'reg', 'cce']


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', '--pcap_folder')
    parser.add_argument('-m', '--message')
    parser.add_argument('-i', '--iterations', type=int)
    parser.add_argument('-o', '--output')
    parser.add_argument('-c', '--carrier_file', default='')
    parser.add_argument('-n', '--nbytes', type=int, default=1000)
    parser.add_argument('--encrypt', action='store_true')
    parser.add_argument('--whole_carrier', action='store_true')
    parser.add_argument('--rand_jump', action='store_true')
    parser.add_argument('--eq_space', action='store_true')

    args = parser.parse_args()

    with open(args.message, 'rb') as f:
        msg = f.read(args.nbytes)

    if args.encrypt:
        key = b'pTuL7zxs6e3dAFMioJoS01OhBrO9SXGw'
        cipher = Salsa20.new(key=key)
        msg = cipher.encrypt(msg)

    bits = [d for c in msg for d in '{0:08b}'.format(c)]
    nbits =  len(bits)

    np.random.seed(17)
    if args.rand_jump:
        jumps = [np.random.randint(1, 10, size=nbits) for _ in range(args.iterations)]
    else:
        jumps = [np.ones(nbits, dtype=int) for _ in range(args.iterations)]


    ids_needed = [np.sum(j) for j in jumps] 
    nids = np.sum(ids_needed)*2

    # pdb.set_trace()


    try:
        with open(args.carrier_file, 'rb') as f:
            all_ids = pkl.load(f)
        if not len(all_ids) >= nids:
            raise IOError
    except IOError:
        all_ids = []
        pcap_files = [args.pcap_folder + pf for pf in os.listdir(args.pcap_folder) if pf.endswith('.pcap')]

        stop_filter = lambda _: len(real_ids) == args.iterations*nbits*2
        
        sniff(offline=pcap_files, 
             prn=partial(get_ip_id, all_ids), 
             store=0, 
             stop_filter= stop_filter)
        
        assert(stop_filter(None))

    if args.carrier_file:
     	with open(args.carrier_file, 'wb') as f:
     	   pkl.dump((real_id_iter, dummy_id_iter), f)

    np.random.shuffle(real_id_iter)
    np.random.shuffle(dummy_id_iter)

    # np.random.shuffle(all_ids)

    real_ids = all_ids[len(all_ids) // 2:]
    dummy_ids = all_ids[:len(all_ids) // 2]

    ids_needed_cum = np.cumsum(ids_needed)
    real_id_iter = [real_ids[b:e] for b,e in zip([0] + list(ids_needed_cum), list(ids_needed_cum))]
    dummy_id_iter = [dummy_ids[b:e] for b,e in zip([0] + list(ids_needed_cum), list(ids_needed_cum))]

    res_dict = {t:[] for t in tests}
    for i in range(args.iterations):
        traces = inject(field_size, real_id_iter[i], bits, jumps[i],
                      args.whole_carrier, args.eq_space)
        add_test(res_dict, 'comp', check_compress, traces)
        add_test(res_dict, 'rep', check_repeat, traces)
        add_test(res_dict, 'brep', check_byte_repeat, traces)
        add_test(res_dict, 'ent', check_entropy, traces)
        add_test(res_dict, 'cov', check_covar, traces)
        add_test(res_dict, 'bent', check_byte_entropy, traces)
        add_test(res_dict, 'lz78', check_lz78_compress, traces)
        add_test(res_dict, 'lz77', check_lz77_compress, traces)
        add_test(res_dict, 'ks', check_ks, traces, dummy_id_iter[i])
        add_test(res_dict, 'wcx', check_wilcoxon, traces, dummy_id_iter[i])
        add_test(res_dict, 'spr', check_spearman, traces, dummy_id_iter[i])
        add_test(res_dict, 'reg', check_regularity, traces)
        add_test(res_dict, 'cce', check_cce, traces)

    
    df_dict = dict([(k, pd.DataFrame(v).T) for k, v in res_dict.items()])

    df = pd.concat(df_dict).T

    df.to_pickle(args.output)






    
def inject(field_size, carrier, message_bits, jumps,
           whole_carrier=False, eq_space=False):
    # bls = []
    traces = []
    nbits = len(message_bits)
    for bp in range(field_size + 1):
        
        pktm = get_pktm(message_bits, bp) if not bp == 0 else [0]*nbits

        # pdb.set_trace()
        if whole_carrier and not eq_space:
            pktm.extend([0] * (nbits - len(pktm)))
        elif eq_space:
            pktm = list(chain(*[[e] + [0]*(bp -1) for e in pktm]))

        pktm = list(chain(*[[e] + [0]*(j - 1) for e, j in zip(pktm, jumps)]))

        mask = ~((1 << bp) - 1)


        trace  = [(b & mask) | m for b, m in zip(carrier, pktm)]
        traces.append(trace)

        # pdb.set_trace()

    return traces

def add_test(res_dict, key, func, traces, *args):
    res_dict[key].append([func(trace, *args) for trace in traces])
    return
    



    
def check_compress(trace):
    btr = b''.join([e.to_bytes(2, byteorder='big') for e in trace])
    return len(lzma.compress(btr)) / len(btr)

def check_lz78_compress(trace):
    btr = b''.join([e.to_bytes(2, byteorder='big') for e in trace])
    return len(lz78.compress(btr)) / len(btr)

def check_lz77_compress(trace):
    btr = b''.join([e.to_bytes(2, byteorder='big') for e in trace])
    return len(lz77.compress(btr)) / len(btr)

def check_repeat(trace):
    return len(set(trace)) / len(trace)

def check_byte_repeat(trace):
    mask = (1 << (field_size // 2)) - 1
    ob_trace = [e & mask for e in trace] + [e & ~mask for e in trace]
    return len(set(ob_trace)) / len(ob_trace)

def check_entropy(trace, nb=field_size):
    _, dist = np.unique(trace, return_counts=True)
    return stats.entropy(dist)

def check_byte_entropy(trace):
    mask = (1 << (field_size // 2)) - 1
    ob_trace = [e & mask for e in trace] + [e & ~mask for e in trace]
    _ , dist = np.unique(ob_trace, return_counts=True)
    return stats.entropy(dist)

def check_covar(trace):
    return onepass_covar(trace)


def check_wilcoxon(trace, dummy_carrier):
    return stats.wilcoxon(trace, dummy_carrier)[0]


def check_spearman(trace, dummy_carrier):
    return stats.spearmanr(trace, dummy_carrier)[0]

def check_ks(trace, dummy_carrier):
    return stats.ks_2samp(trace, dummy_carrier)[0]


def check_regularity(trace):
    return regularity(trace)

def check_cce(trace):
    return cce(trace)

def cce(tr):
    N = len(tr)
    e = [0]
    cce = []
    for L in range(1,N):
        space = [tuple(tr[i:i+L]) for i in range(N-L+1)]
        un,cnt = np.unique(space, return_counts=True, axis=0)
        e.append(stats.entropy(cnt))
        ceL = e[L] - e [L-1]
        percL = un.shape[0] / len(space)
        cce.append(ceL + percL*e[1])
        # print(e[L], percL, ceL, cce[L-1])
        if percL == 1.0: 
            break
    return min(cce)



def regularity(tr):
    n = int(np.ceil(np.sqrt(len(tr))))
    ll = [tr[i:i + n] for i in range(0, len(tr), n)]
    stds = [np.std(l) for l in ll]
    combs = []
    for j in range(len(stds)):
        for i in range(j):
            combs.append(np.abs(stds[i] - stds[j]) / stds[i])
    return np.std(combs)

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
