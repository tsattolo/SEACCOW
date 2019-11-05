#!/usr/bin/env python3


import sys
import pandas as pd
import pdb
from tabulate import tabulate
from itertools import chain


tests = ['comp', 'lz77', 'lz78', 'lzc', 'ent', 'cce', 'rep', 'cov', 'ks', 'wcx', 'spr', 'reg']

rows = [
        'LZMA Compression',
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
n_cols = 3
undef_symbol = '\\perp'

def main():
    df_files = sys.argv[1:]
    

    df_list = [pd.read_pickle(e) for e in df_files]
    n_df = len(df_list)

    if n_df == 1:
        table = []
        rows_wb = rows
        columns_wb = columns
    elif n_df == len(variations):
        rows_wb = ['Encrypted?'] +  ['\hline\n' + rows[0]] + rows[1:]
        columns_wb = chain(*[[c] + ['']*1 for c in columns])     
        table = [variations * n_cols]
    else:
        assert False, 'Number of dataframes does not match number of variations'

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
                vals = [undef_symbol] * n_cols
            else:
                vals = ['%.3g' % cohend[1], '%.3g' % cohend.min(), '%d' % cohend.idxmin()]

            row.append(vals)
            
            # for c,v in zip(cols, vals):
            #     c.append(v)

        table.append(list(chain(*zip(*row))))


        
        # row = ['%s / %s / %s / %s' % tuple(c) for c in cols]
        # table.append(row)
    # columns_wm = ['\\rotcol{%s}' % c for c in columns]
    print(tabulate(table, headers=columns_wb, showindex=rows_wb, tablefmt='latex_raw'))
    

if __name__ == "__main__":
    main()
