#!/bin/bash

dest=~/ThomasSattolo-MASc/Papers/EvaluatingStatTests/Tables/
folder='results_1000iter/'
# nbytes=256
# ./table.py $folder'1E_'$nbytes'.df' $folder'1_'$nbytes'.df' >$dest$nbytes'byte.tex'
# ./table_corr.py $folder'1_'$nbytes'.df' >$dest$nbytes'corr.tex'
# nbytes=16
# ./table.py $folder'1E_'$nbytes'.df' $folder'1_'$nbytes'.df' > $dest$nbytes'byte.tex'
# ./table_corr.py $folder'1_'$nbytes'.df' >$dest$nbytes'corr.tex'
nbytes=1
 ./table.py $folder'1E_'$nbytes'.df' $folder'1_'$nbytes'.df' > $dest$nbytes'byte.tex'
# ./table.py $folder'1_'$nbytes'.df' > $dest$nbytes'byte.tex'
