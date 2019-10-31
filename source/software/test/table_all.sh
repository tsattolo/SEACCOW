#!/bin/bash

./table.py results/1E_100.df results/1_100.df > ~/ThomasSattolo-MASc/Papers/EvaluatingStatTests/Tables/100byte.tex
./table.py results/1E_10.df results/1_10.df > ~/ThomasSattolo-MASc/Papers/EvaluatingStatTests/Tables/10byte.tex
./table.py results/1E_1.df results/1_1.df > ~/ThomasSattolo-MASc/Papers/EvaluatingStatTests/Tables/1byte.tex
