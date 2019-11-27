#!/usr/bin/env python3


import sys, os
import pandas as pd
import numpy as np
import pdb
from sklearn.linear_model import LogisticRegression
import tabulate
import argparse
import library as lib

all_tests = lib.complexity_tests

test_sets = [[t] for t in all_tests] + [all_tests]

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-o', '--output')
    parser.add_argument('-d', '--dataframes', nargs='+')
    parser.add_argument('-n', '--nbytes', nargs='+', type=int)
    parser.add_argument('-t', '--table_format', default='simple', choices=tabulate.tabulate_formats)
    parser.add_argument('-b', '--bit', default=1, type=int)
    parser.add_argument('-p', '--permumtations', default=1000, type=int)
    args = parser.parse_args()

    df_list = [pd.read_pickle(e) for e in args.dataframes]

    if 'latex' in args.table_format:
        std_symbol = '$\\pm$' 
        pre = '\\hline\\begin{tabular}{@{}l@{}} '
        post = '\\end{tabular}'
        splitter = ' \\\\ '
    else:
        std_symbol = '+/-' 
        pre = ''
        post = ''
        splitter = ', '

    

    table = []
    
    for tests in test_sets:
        # print(tests)
        row = []
        for df in df_list:
            pos_ex = np.array([df[t][args.bit] for t in tests]).T
            neg_ex = np.array([df[t][0] for t in tests]).T
            
            examples = np.concatenate((pos_ex, neg_ex))
            labels = np.concatenate((np.ones(len(pos_ex)), np.zeros(len(neg_ex))))

            
            N = len(examples)
            split = int(0.7*N)
            assert(len(examples) == len(labels))

            acclist = []

            for i in range(args.permumtations):
                p = np.random.permutation(N)
                
                train_ex = examples[p][:split].copy()
                train_lb = labels[p][:split].copy()
                test_ex = examples[p][split:].copy()
                test_lb = labels[p][split:].copy()

                clf = LogisticRegression(solver='lbfgs', max_iter=1000).fit(train_ex,  train_lb)
                
                accuracy = clf.score(test_ex, test_lb)
                acclist.append(accuracy)
            
            row.append('%.3g %s %.2g' % (np.mean(acclist), std_symbol, np.std(acclist)))
        table.append(row)


    rownames = [splitter.join(t.upper() for t in tests) for tests in test_sets] 
    rownames = ['All' if t == all_tests else r for t,r in zip(test_sets, rownames)]
    rownames = [pre + r + post for r in rownames]

    columns = ['Message Bytes'] + ['%d byte%s' % (nb, '' if nb == 1 else 's') for nb in args.nbytes]

    with open(args.output, 'w') as f:
        f.write(tabulate.tabulate(table, headers=columns, showindex=rownames, tablefmt=args.table_format))

    


    
    # pdb.set_trace()


    

if __name__ == "__main__":
    main()
