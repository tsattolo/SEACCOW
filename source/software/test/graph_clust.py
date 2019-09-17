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
                'tests1WC.df',
                ]
    nbits = [1000, 100, 10, 1]
    df_list = [pd.read_pickle(e) for e in df_files]
    
    
    for df,nb in zip(df_list, nbits):
        plt.figure()
        xp = df[tx][1]
        xn = df[tx][0]

        yp = df[ty][1]
        yn = df[ty][0]

        
        examples = np.concatenate((np.array([xp, yp]).T, np.array([xn,yn]).T))
        labels = np.concatenate((np.ones(len(xp)), np.zeros(len(yp))))

        
        N = len(examples)
        split = int(0.7*N)
        assert(len(examples) == len(labels))

        acclist = []

        for i in range(1000):
            p = np.random.permutation(N)
            
            train_ex = examples[p][:split].copy()
            train_lb = labels[p][:split].copy()
            test_ex = examples[p][split:].copy()
            test_lb = labels[p][split:].copy()

            clf = LogisticRegression(solver='lbfgs').fit(train_ex,  train_lb)
            
            accuracy = clf.score(test_ex, test_lb)
            acclist.append(accuracy)

            if i == 1:
                xx, yy = np.mgrid[0:1:.01, 6:10:.01]
                grid = np.c_[xx.ravel(), yy.ravel()]
                probs = clf.predict_proba(grid)[:, 1].reshape(xx.shape)
                
                f, ax = plt.subplots(figsize=(8, 6))
                contour = ax.contourf(xx, yy, probs, 25, cmap="RdBu",
                                      vmin=0, vmax=1)
                ax_c = f.colorbar(contour)
                ax_c.set_label("Estimated Probability of Covert Channel")
                ax_c.set_ticks([0, .25, .5, .75, 1])


                ax.scatter(test_ex[:,0], test_ex[:, 1], c=test_lb, s=50,
                           cmap="RdBu", vmin=-.2, vmax=1.2,
                           edgecolor="white", linewidth=1)

                ax.set( xlim=(0, 1), ylim=(6, 10), xlabel="Repetition", ylabel="LZ77")

                plt.savefig('clust/%i_%s_%s.png' %  (nb, tx, ty)) 
                plt.savefig('clust/%i_%s_%s.pdf' %  (nb, tx, ty)) 

                print('%d: %f' % (nb, accuracy))
            
        print('mean: %d: %f' % (nb, np.mean(acclist)))
        print('std:  %d: %f' % (nb, np.std(acclist)))

    


    
    # pdb.set_trace()


    

if __name__ == "__main__":
    main()
