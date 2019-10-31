#!/usr/bin/env python3


import sys
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import pdb
from tabulate import tabulate

from scipy import stats

tests = ['comp', 'lz77', 'lz78', 'lzc', 'ent', 'cce', 'rep']

rows = [
        'LZMA Compression',
        'LZ77 Compression',
        'LZ78 Compression',
        'Lempel-Ziv Complexity',
        'First-Order Entropy',
        'Corr. Cond. Entropy',
        'Repetition',
        ]

td =  {t:tests for t in tests}

def main():
    df_files = sys.argv[1:]
    df_list = [pd.read_pickle(e) for e in df_files]
    table = []
    for ct,tl in td.items():
        for df in df_list:
            row = []
            for t in tl:
                x = df[t][1] - df[t][0]
                y = df[ct][1] - df[ct][0]
                row.append(np.corrcoef(x,y)[0][1])
            table.append(['%.2g' % r for r in row])

    
    columns_wm = ['\\rotcol{%s}' % c for c in rows]
    print(tabulate(table, headers=columns_wm, showindex=rows, tablefmt='latex_raw'))
    


if __name__ == "__main__":
    main()
