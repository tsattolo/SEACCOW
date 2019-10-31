#!/usr/bin/env python3


import sys
import pandas as pd
import pdb
from tabulate import tabulate
from itertools import chain


tests = ['comp', 'lz77', 'lz78', 'lzc', 'ent', 'cce', 'rep', 'cov', 'ks', 'wcx', 'spr', 'reg']

rows = [
        '\hline\n' + 'LZMA Compression',
        'LZ77 Compression',
        'LZ78 Compression',
        'Lempel-Ziv Complexity',
        'First-Order Entropy',
        'Corr. Cond. Entropy',
        'Repetition',
        'Autocovariance',
        'Kolm.-Smirnov Test',
        'Wilcoxon Signed Rank',
        'Spearman Correlation',
        'Regularity'
        ]

columns = ['1-bit Trace', 'Minimum', 'Min. Index']
# variations = ['Neither', 'Encrypted', 'Jump', 'Both']
variations = ['Y', 'N']
def main():
    df_files = sys.argv[1:]
    

    df_list = [pd.read_pickle(e) for e in df_files]

    table = [variations * 3]
    for t in tests:
        # cols = [[] for _ in columns]
        row = []
        for df, variation in zip(df_list, variations):
            dft = df[t]
            dfnz = dft.loc[:,1:]
            dfnz -= pd.concat([dft[0]] * len(dfnz.columns), axis='columns').values # Subtract zero column from the others
            
            sd = ((dfnz.var() + dft[0].var())/2).pow(0.5)
            cohend = (dfnz.mean() / sd).abs()
            
            
            
            if cohend[1] != cohend[1]:
                vals = ['Undef.', 'Undef.', 'Undef.']
            else:
                vals = ['%.3g' % cohend[1], '%.3g' % cohend.min(), '%d' % cohend.idxmin()]

            row.append(vals)
            
            # for c,v in zip(cols, vals):
            #     c.append(v)

        table.append(list(chain(*zip(*row))))


        
        # row = ['%s / %s / %s / %s' % tuple(c) for c in cols]
        # table.append(row)
    rows_wb = ['Encrypted?'] +    rows 
    # columns_wm = ['\\rotcol{%s}' % c for c in columns]
    columns_wb = chain(*[[c] + ['']*1 for c in columns])     
    print(tabulate(table, headers=columns_wb, showindex=rows_wb, tablefmt='latex_raw'))
    

if __name__ == "__main__":
    main()
