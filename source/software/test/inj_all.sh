#!/bin/bash

iter=100
# 1000 bits
nbits=1000
./inject.py -p pcap/ -m message.txt -n $nbits -i $iter -o 'tests'$nbits'WC.df'     --whole_carrier > $nbits'WC.txt'&
./inject.py -p pcap/ -m message.txt -n $nbits -i $iter -o 'tests'$nbits'XRWC.df'   --whole_carrier --xor_rand > $nbits'XRWC.txt'&
./inject.py -p pcap/ -m message.txt -n $nbits -i $iter -o 'tests'$nbits'EQWC.df'   --whole_carrier --eq_space > $nbits'EQWC.txt'&
./inject.py -p pcap/ -m message.txt -n $nbits -i $iter -o 'tests'$nbits'EQXRWC.df' --whole_carrier --xor_rand --eq_space > $nbits'EQXRWC.txt'&

# 100 bits
nbits=100 
./inject.py -p pcap/ -m message.txt -n $nbits -i $iter -o 'tests'$nbits'WC.df'     --whole_carrier > $nbits'WC.txt'& 
./inject.py -p pcap/ -m message.txt -n $nbits -i $iter -o 'tests'$nbits'XRWC.df'   --whole_carrier --xor_rand > $nbits'XRWC.txt'&
./inject.py -p pcap/ -m message.txt -n $nbits -i $iter -o 'tests'$nbits'EQWC.df'   --whole_carrier --eq_space > $nbits'EQWC.txt'&
./inject.py -p pcap/ -m message.txt -n $nbits -i $iter -o 'tests'$nbits'EQXRWC.df' --whole_carrier --xor_rand --eq_space > $nbits'EQXRWC.txt'&

# 10 bits
nbits=10
./inject.py -p pcap/ -m message.txt -n $nbits -i $iter -o 'tests'$nbits'WC.df'     --whole_carrier > $nbits'WC.txt'& 
./inject.py -p pcap/ -m message.txt -n $nbits -i $iter -o 'tests'$nbits'XRWC.df'   --whole_carrier --xor_rand > $nbits'XRWC.txt'&
./inject.py -p pcap/ -m message.txt -n $nbits -i $iter -o 'tests'$nbits'EQWC.df'   --whole_carrier --eq_space > $nbits'EQWC.txt'&
./inject.py -p pcap/ -m message.txt -n $nbits -i $iter -o 'tests'$nbits'EQXRWC.df' --whole_carrier --xor_rand --eq_space > $nbits'EQXRWC.txt'&
