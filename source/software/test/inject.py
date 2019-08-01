#!/usr/bin/env python3

from scapy.all import *
import sys
import random
import pdb
import lzma

real_ids = []
gen_ids = []
zero_ids = []
bits_per = 8
testdir = 'test_files'

field_size = 16

def main():
    pcap_file = sys.argv[1]
    message = sys.argv[2]
    
    with open(message, 'rb') as f:
        msg = list(f.read())
    
    bits = [d for c in msg for d in '{0:08b}'.format(c)]
    
    sniff(offline=pcap_file, prn=get_ip_id,store=0, stop_filter=lambda _ : len(real_ids) == len(bits))
    assert(len(bits) <= len(real_ids))

    # random.seed(17)
    # gen_ids = [random.getrandbits(13) for _ in range(len(bits))]
    # zero_ids = [0] * len(bits)
    
    try: 
        os.mkdir(testdir)
    except:
        pass

    test_dict = {'real':real_ids} # 'gen':gen_ids, 'zero':zero_ids} 
    bls = []
    for bp in range(field_size + 1):

        for k, v in test_dict.items():
            filename = '%s/%s%i.bin' % (testdir, k, bp)
            pktm = get_pktm(bits, bp) if not bp == 0 else []
            pktm.extend([0] * (len(v) - len(pktm)))
            with open(filename, 'wb') as f:
                bl  = [(b ^ m).to_bytes(2, byteorder='big') for b, m in zip(v, pktm)]
                # pdb.set_trace()
                f.write(b''.join(bl))
            bls.append(bl)

    pdb.set_trace()
    

    res = []
    for fn in os.listdir(testdir):
        with open(testdir + '/' + fn, 'rb') as f:
            b = f.read()
            bc = lzma.compress(b)
            bl = [b[n:n+2] for n in range(0,len(b),2)]
            res.append((len(bc)/len(b), fn, len(bl) - len(set(bl))))
            # pdb.set_trace()

    res.sort()
    for r in res:
        print('%s: %f, repeats: %d' % (r[1], r[0], r[2]))

            








def get_pktm(bits, bits_per): 
    pktb = [bits[i:i+bits_per] for i in range(0, len(bits), bits_per)]
    return [int(''.join(m), 2) for m in pktb]
    

def get_ip_id(pkt):
    if IP in pkt:
        real_ids.append(pkt['IP'].fields['id'])


    
    

    
    


if __name__ == "__main__":
    main()
