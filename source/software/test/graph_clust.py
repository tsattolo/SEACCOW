#!/usr/bin/env python3


import sys
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import pdb

from scipy import stats

tx = 'rep'
ty = 'lz77'

def main():
    df_files = [
                'tests1000WC.df',
                'tests100WC.df',
                'tests10WC.df',
                ]
    nbits = [1000, 100, 10]
    df_list = [pd.read_pickle(e) for e in df_files]

    
    for df,nb in zip(df_list, nbits):
        plt.figure()
        xp = df[tx][1]
        xn = df[tx][0]

        yp = df[ty][1]
        yn = df[ty][0]
        

        plt.scatter(xp, yp, marker='+')
        plt.scatter(xn, yn, marker='x')
    


    
        plt.savefig('clust/%i_%s_%s.png' %  (nb, tx, ty)) 
        plt.savefig('clust/%i_%s_%s.eps' %  (nb, tx, ty)) 

    # pdb.set_trace()


    

if __name__ == "__main__":
    main()
