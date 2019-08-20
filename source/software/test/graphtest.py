#!/usr/bin/env python3


import sys
import pandas as pd
import matplotlib.pyplot as plt
import pdb

tests = ['comp', 'rep', 'brep', 'ent', 'cov']

def main():
    df_file = sys.argv[1]
    df = pd.read_pickle(df_file)
    

    for t in tests:
        dft = df[t]
        dfnz = dft.loc[:,1:]
        # pdb.set_trace()
        dfnz -= pd.concat([dft[0]] * len(dfnz.columns), axis='columns').values # Subtract zero column from the others

        
        sd = ((dfnz.var() + dft[0].var())/2).pow(0.5)
        print("Cohen's D for %s:" % t)
        print(dfnz.mean() / sd)
        
        
        plt.figure()
        plt.plot(dfnz.mean(), 'ko')
        plt.errorbar(dfnz.columns, dfnz.mean(), yerr=dfnz.std(), linestyle='None')
        plt.xticks(dfnz.columns)

        plt.savefig('%s_%s.eps' % (df_file.split('.')[0], t)) 
    

    

if __name__ == "__main__":
    main()
