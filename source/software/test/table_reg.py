#!/usr/bin/env python3


import sys
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import pdb
import seaborn as sns
from sklearn.linear_model import LogisticRegression
from scipy import stats
from tabulate import tabulate


sns.set(style="white")

full_names = [
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

all_tests = ['comp', 'lz77', 'lz78', 'lzc', 'ent', 'cce', 'rep'] #, 'cov', 'ks', 'wcx', 'spr', 'reg']

name_dict = dict(zip(all_tests, full_names))

test_sets = [
                ['comp'],
                ['lz77'],
                ['lz78'],
                ['lzc'],
                ['ent'],
                ['cce'],
                ['rep'],
                all_tests,
                # ['rep', 'lz77'],
                # ['rep', 'comp'],
                # ['lz78', 'comp']
            ]
nperm = 1000

def main():
    df_files = [
                'results_1000iter/1_256.df',
                'results_1000iter/1_64.df',
                'results_1000iter/1_16.df',
                'results_1000iter/1_4.df',
                'results_1000iter/1_1.df',
                ]
    nbytes = [256, 64, 16, 4, 1]
    df_list = [pd.read_pickle(e) for e in df_files]
    

    table = []
    
    for tests in test_sets:
        # print(tests)
        row = []
        for df,nb in zip(df_list, nbytes):
            pos_ex = np.array([df[t][1] for t in tests]).T
            neg_ex = np.array([df[t][0] for t in tests]).T
            
            examples = np.concatenate((pos_ex, neg_ex))
            labels = np.concatenate((np.ones(len(pos_ex)), np.zeros(len(neg_ex))))

            
            N = len(examples)
            split = int(0.7*N)
            assert(len(examples) == len(labels))

            acclist = []

            for i in range(nperm):
                p = np.random.permutation(N)
                
                train_ex = examples[p][:split].copy()
                train_lb = labels[p][:split].copy()
                test_ex = examples[p][split:].copy()
                test_lb = labels[p][split:].copy()

                clf = LogisticRegression(solver='lbfgs', max_iter=1000).fit(train_ex,  train_lb)
                
                accuracy = clf.score(test_ex, test_lb)
                acclist.append(accuracy)
            
            row.append('%.3g $\\pm$ %.2g' % (np.mean(acclist), np.std(acclist)))
            # print('mean: %d: %f' % (nb, np.mean(acclist)))
            # print('std:  %d: %f' % (nb, np.std(acclist)))
        table.append(row)

    pre = '\\hline\\begin{tabular}{@{}l@{}} '
    post = '\\end{tabular}'

    rownames = [' \\\\ '.join([name_dict[t]  for t in tests]) for tests in test_sets] 
    rownames = ['All' if t == all_tests else r for t,r in zip(test_sets, rownames)]
    rownames = [pre + r + post for r in rownames]
    print(tabulate(table, headers=nbytes, showindex=rownames, tablefmt='latex_raw'))

    


    
    # pdb.set_trace()


    

if __name__ == "__main__":
    main()
