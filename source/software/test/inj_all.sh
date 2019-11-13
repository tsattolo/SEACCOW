#!/bin/bash

iter=1000
folder='results_1000iter/'
carrier='carrier2.pkl'

# 100 bytes
nbytes=256
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'1_'$nbytes'.df'      -j 1&
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'1E_'$nbytes'.df'     -j 1 --encrypt&
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'5_'$nbytes'.df'      -j 5&
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'5E_'$nbytes'.df'     -j 5 --encrypt &

# 10 bytes
nbytes=16 
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'1_'$nbytes'.df'      -j 1&
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'1E_'$nbytes'.df'     -j 1 --encrypt&
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'5_'$nbytes'.df'      -j 5&
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'5E_'$nbytes'.df'     -j 5 --encrypt &

# 1 byte
nbytes=1 
./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'1_'$nbytes'.df'      -j 1&
./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'1E_'$nbytes'.df'     -j 1 --encrypt&
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'5_'$nbytes'.df'      -j 5&
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'5E_'$nbytes'.df'     -j 5 --encrypt&

# nbytes=4
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'1_'$nbytes'.df'      -j 1&
# nbytes=64
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'1_'$nbytes'.df'      -j 1&
# nbytes=1024
# ./inject.py -m message.txt -c $carrier -n $nbytes -i $iter -o $folder'1_'$nbytes'.df'      -j 1&
