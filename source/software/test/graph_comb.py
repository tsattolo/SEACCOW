#!/usr/bin/env python3


import sys
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import pdb

from scipy import stats

tests = {'lz77':['comp', 'ent', 'lz78', 'rep', 'lz77'], 
         'rep':['comp', 'ent', 'lz78', 'rep', 'lz77']}

def main():
    df_files = [
                'tests1000WC.df',
                'tests100WC.df',
                'tests10WC.df',
                ]
    nbits = [1000, 100, 10]
    df_list = [pd.read_pickle(e) for e in df_files]

    for df,nb in zip(df_list, nbits):
        for ct,tl in tests.items():
            for t in tl:
                plt.figure()
                x = df[t][1] - df[t][0]
                y = df[ct][1] - df[ct][0]
                

                plt.scatter(x, y)
                
                slope, intercept, r_value, p_value, std_err = stats.linregress(x, y)
                plt.plot(x, slope*x + intercept)


                
                # plt.savefig('%.eps' %  t) 
                plt.savefig('combtests/%d_%s_%s.png' %  (nb, t, ct)) 
                plt.savefig('combtests/%d_%s_%s.pdf' %  (nb, t, ct)) 

                # pdb.set_trace()

                print('Corr %s %s: %f' % (t, ct, np.corrcoef(x,y)[0][1]))
    

    

if __name__ == "__main__":
    main()
