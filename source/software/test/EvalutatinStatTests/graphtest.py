#!/usr/bin/env python3


import sys
import pandas as pd
import matplotlib.pyplot as plt
import pdb
from tabulate import tabulate

tests = ['comp', 'lz77', 'lz78', 'lzc', 'ent', 'cce', 'rep', 'cov', 'ks', 'wcx', 'spr', 'reg']

rows = [
        'LZMA Compression',
        'LZ77 Compression',
        'LZ78 Compression',
        'Lempel-Ziv Complexity',
        'First-Order Entropy',
        'Corrected Conditional Entropy',
        'Repetition',
        'Autocovariance',
        'Kolmogorov-Smirnov Test',
        'Wilcoxon Signed Rank',
        'Spearman Correlation',
        'Regularity'
        ]

columns = ['1-bit Trace Effect Size', 'Minimum Effect Size', 'Minimum Effect Size Trace']

def main():
    # df_files = ['testsWC.df', 'testsEQWC.df', 'testsXRWC.df', 'testsEQXRWC.df']
    # df_files = ['tests_rj.df','tests_nrj.df', 'tests10WC.df' ]
    df_files = sys.argv[1:]
    

    # df_files = [
    #             'tests1000WC.df',
    #             'tests1000EQWC.df',
    #             'tests1000XRWC.df',
    #             'tests1000EQXRWC.df',
    #             'tests100WC.df',
    #             'tests100EQWC.df',
    #             'tests100XRWC.df',
    #             'tests100EQXRWC.df',
    #             'tests10WC.df',
    #             'tests10EQWC.df',
    #             'tests10XRWC.df',
    #             'tests10EQXRWC.df',
    #             ]

    df_list = [pd.read_pickle(e) for e in df_files]
    styles = ['b.', 'r.', 'g.', 'y.'] + ['bx', 'rx', 'gx', 'yx'] + ['b+', 'r+', 'g+', 'y+']
    names = ['Neither', 'Spaced', 'XORed', 'Both'] * 3
    assert(len(styles) >= len(df_list))

    table = []
    for t in tests:
        plt.figure()
        for (df, style, name) in zip(df_list, styles, names):
            dft = df[t]
            dfnz = dft.loc[:,1:]
            # pdb.set_trace()
            dfnz -= pd.concat([dft[0]] * len(dfnz.columns), axis='columns').values # Subtract zero column from the others

            
            sd = ((dfnz.var() + dft[0].var())/2).pow(0.5)
            # print("Min Cohen's D for %s:" % t)
            cohend = (dfnz.mean() / sd).abs()
            # print('%d, %f' %(cohend.idxmin(), cohend.min()))
           
            table.append([cohend[1], cohend.min(), cohend.idxmin()])
            
            plt.plot(cohend, style, label=name)
            # plt.errorbar(dfnz.columns, dfnz.mean(), yerr=dfnz.std(), linestyle='None')
            plt.xticks(dfnz.columns)
            # plt.legend()
            plt.ylim(0,20)
            plt.xlabel('Bits / Element')
            plt.ylabel('Effect Size')

        
        plt.savefig('testplots/%s.pdf' %  t) 
        plt.savefig('testplots/%s.png' %  t) 
    
    pdb.set_trace()
    print(tabulate(table, headers=columns, showindex=rows))
    

if __name__ == "__main__":
    main()