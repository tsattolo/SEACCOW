#!/bin/bash

dest=~/ThomasSattolo-MASc/Papers/EvaluatingStatTests/Tables/
nbytes=256
./table.py 'results/1E_'$nbytes'.df' 'results/1_'$nbytes'.df' >$dest$nbytes'byte.tex'
nbytes=16
./table.py 'results/1E_'$nbytes'.df' 'results/1_'$nbytes'.df' > $dest$nbytes'byte.tex'
nbytes=1
# ./table.py 'results/1E_'$nbytes'.df' 'results/1_'$nbytes'.df' > $dest$nbytes'byte.tex'
./table.py 'results/1_'$nbytes'.df' > $dest$nbytes'byte.tex'
