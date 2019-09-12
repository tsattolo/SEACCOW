#!/usr/bin/env python3


import sys
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import pdb
import seaborn as sns
from sklearn.linear_model import LogisticRegression
from scipy import stats

tx = 'rep'
ty = 'lz77'

sns.set(style="white")

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

        
        examples = np.concatenate((np.array([xp, yp]).T, np.array([xn,yn]).T))
        labels = np.concatenate((np.ones(len(xp)), np.zeros(len(yp))))

        
        clf = LogisticRegression(solver='lbfgs').fit(examples, labels)
        xx, yy = np.mgrid[0:1:.01, 7:10:.01]
        grid = np.c_[xx.ravel(), yy.ravel()]
        probs = clf.predict_proba(grid)[:, 1].reshape(xx.shape)
        
        f, ax = plt.subplots(figsize=(8, 6))
        contour = ax.contourf(xx, yy, probs, 25, cmap="RdBu",
                              vmin=0, vmax=1)
        ax_c = f.colorbar(contour)
        ax_c.set_label("$P(y = 1)$")
        ax_c.set_ticks([0, .25, .5, .75, 1])


        ax.scatter(examples[:,0], examples[:, 1], c=labels, s=50,
                   cmap="RdBu", vmin=-.2, vmax=1.2,
                   edgecolor="white", linewidth=1)

        ax.set( xlim=(0, 1), ylim=(7, 10), xlabel="$X_1$", ylabel="$X_2$")

        

        # plt.scatter(xp, yp, marker='+')
        # plt.scatter(xn, yn, marker='x')
    


    
        plt.savefig('clust/%i_%s_%s.png' %  (nb, tx, ty)) 
        plt.savefig('clust/%i_%s_%s.pdf' %  (nb, tx, ty)) 

    # pdb.set_trace()


    

if __name__ == "__main__":
    main()
