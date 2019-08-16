#!/usr/bin/env python3


import sys
import pandas as pd
import matplotlib.pyplot as plt
import pdb

tests = ['comp', 'rep', 'ent']

def main():
    df_file = sys.argv[1]
    df = pd.read_pickle(df_file)
    

    for t in tests:
        dft = df[t]
        dfnz = dft.loc[:,1:]
        # pdb.set_trace()
        dfnz -= pd.concat([dft[0]] * len(dfnz.columns), axis='columns').values # Subtract zero column from the others
        
        
        

        plt.figure()
        plt.plot(dfnz.mean(), 'ko')
        plt.errorbar(dfnz.columns, dfnz.mean(), yerr=dfnz.std(), linestyle='None')
        plt.xticks(dfnz.columns)

        plt.savefig('%s_%s.png' % (df_file.split('.')[0], t)) 
    

    

if __name__ == "__main__":
    main()
