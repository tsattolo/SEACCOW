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
ty = 'lzc'

sns.set(style="white")

n_iter = 1

plt.rcParams.update({'font.size': 36})
# plt.rcParams.update({'figure.autolayout': True})

def main():
    df_files = [sys.argv[1] + fn for fn in ['256.df', '64.df', '16.df', '4.df', '1.df']]
    # df_files = [
    #             'tests1000WC.df',
    #             'tests100WC.df',
    #             'tests10WC.df',
    #             'tests1WC.df',
    #             ]
    nbits = [256, 64, 16, 4, 1]
    df_list = [pd.read_pickle(e) for e in df_files]
    
    
    for df,nb in zip(df_list, nbits):
        plt.figure()
        
        mean = np.mean([df[tx][1], df[tx][0] ])
        std = np.std([df[tx][1], df[tx][0] ])
        xp = (df[tx][1] - mean) / std
        xn = (df[tx][0] - mean) / std

        mean = np.mean([df[ty][1], df[ty][0] ])
        std = np.std([df[ty][1], df[ty][0] ])
        yp = (df[ty][1] - mean) / std
        yn = (df[ty][0] - mean) / std

        
        examples = np.concatenate((np.array([xp, yp]).T, np.array([xn,yn]).T))
        # examples -= np.mean(examples)
        # examples /= np.std(examples)
        labels = np.concatenate((np.ones(len(xp)), np.zeros(len(yp))))

        
        N = len(examples)
        split = int(0.7*N)
        assert(len(examples) == len(labels))

        acclist = []

        for i in range(n_iter):
            p = np.random.permutation(N)
            
            train_ex = examples[p][:split].copy()
            train_lb = labels[p][:split].copy()
            test_ex = examples[p][split:].copy()
            test_lb = labels[p][split:].copy()

            clf = LogisticRegression(solver='lbfgs').fit(train_ex,  train_lb)
            
            accuracy = clf.score(test_ex, test_lb)
            acclist.append(accuracy)

            if i == 0:
                xx, yy = np.mgrid[-3:3:.01, -3:3:.01]
                grid = np.c_[xx.ravel(), yy.ravel()]
                probs = clf.predict_proba(grid)[:, 1].reshape(xx.shape)
                
                f, ax = plt.subplots(figsize=(8, 6))
                contour = ax.contourf(xx, yy, probs, 250, cmap="RdBu",
                                      vmin=0, vmax=1)
                ax_c = f.colorbar(contour)
                ax_c.set_label("Estimated Probability of Covert Channel")
                ax_c.set_ticks([0, .25, .5, .75, 1])


                ax.scatter(test_ex[:,0], test_ex[:, 1], c=test_lb, s=50,
                           cmap="RdBu", vmin=-.2, vmax=1.2,
                           edgecolor="white", linewidth=1)

                ax.set( xlim=(-3, 3), ylim=(-3, 3), xlabel=tx.upper(), ylabel=ty.upper())

                plt.savefig('clust/%i_%s_%s.png' %  (nb, tx, ty)) 
                plt.savefig('clust/%i_%s_%s.pdf' %  (nb, tx, ty)) 

                print('%d: %f' % (nb, accuracy))
            
        print('mean: %d: %f' % (nb, np.mean(acclist)))
        print('std:  %d: %f' % (nb, np.std(acclist)))

    


    
    # pdb.set_trace()


    

if __name__ == "__main__":
    main()
