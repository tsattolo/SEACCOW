#!/bin/bash

iter=100
folder='results/'

# 100 bytes
nbytes=100 
./inject.py -m message.txt -c carrier.pkl -n $nbytes -i $iter -o $folder'1_'$nbytes'.df'      -j 1&
./inject.py -m message.txt -c carrier.pkl -n $nbytes -i $iter -o $folder'1E_'$nbytes'.df'     -j 1 --encrypt&
./inject.py -m message.txt -c carrier.pkl -n $nbytes -i $iter -o $folder'5_'$nbytes'.df'      -j 5&
./inject.py -m message.txt -c carrier.pkl -n $nbytes -i $iter -o $folder'5E_'$nbytes'.df'     -j 5 --encrypt &

# 10 bytes
nbytes=10 
./inject.py -m message.txt -c carrier.pkl -n $nbytes -i $iter -o $folder'1_'$nbytes'.df'      -j 1&
./inject.py -m message.txt -c carrier.pkl -n $nbytes -i $iter -o $folder'1E_'$nbytes'.df'     -j 1 --encrypt&
./inject.py -m message.txt -c carrier.pkl -n $nbytes -i $iter -o $folder'5_'$nbytes'.df'      -j 5&
./inject.py -m message.txt -c carrier.pkl -n $nbytes -i $iter -o $folder'5E_'$nbytes'.df'     -j 5 --encrypt &

# 1 byte
nbytes=1 
./inject.py -m message.txt -c carrier.pkl -n $nbytes -i $iter -o $folder'1_'$nbytes'.df'      -j 1&
./inject.py -m message.txt -c carrier.pkl -n $nbytes -i $iter -o $folder'1E_'$nbytes'.df'     -j 1 --encrypt&
./inject.py -m message.txt -c carrier.pkl -n $nbytes -i $iter -o $folder'5_'$nbytes'.df'      -j 5&
./inject.py -m message.txt -c carrier.pkl -n $nbytes -i $iter -o $folder'5E_'$nbytes'.df'     -j 5 --encrypt&
