#!/usr/bin/env python3
import random
import subprocess
import pdb
import time
import sys

def main():
    dump = '-d' in sys.argv

    random.seed(time.time())
    subprocess.run(['iverilog',
                    '-o', 'rep_tb',
                    'repetition_test.sv', 
                    '../fast_rep.sv', 
                    '-g2012'],
                    check=True)

    nbs = [random.randint(1,16) for _ in range(100)]
    nelems = [random.randint(1,20) for _ in range(100)]
    
    for nb, nelem in zip(nbs, nelems):
        runtest(nb, nelem, dump)

    print("All tests passed")

def rindex(mylist, myvalue):
    return len(mylist) - mylist[::-1].index(myvadaplue) - 1 if myvalue in mylist else 0
   

def runtest(nb, nelem, d):
    filename = 'reptest.dat'
    trace = [random.getrandbits(nb) for _ in range(nelem)]
    clear_lines = range(0, nelem, random.randint(8, nelem-1)) if nelem > 8 else [0]
    trace = [-1 if i in clear_lines else t for i,t in enumerate(trace)]
    lc = clear_lines[-1] 
    reps = len(trace[lc + 1:]) - len(set(trace[lc + 1:]))
    
    with open(filename, 'w') as f:
        f.write('%d\n' % reps) 
        for tr in trace: 
            f.write('%d\n' % tr)

    cproc = subprocess.run(['vvp', 'rep_tb', '+FN='+filename, '+dump='+str(int(d))],
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)
    
    # print(cproc.stdout.split(b'\n')[-2])
    # print(trace)
    # # pdb.set_trace()

    if b'Failed' in cproc.stdout:
        print(cproc.stdout)
        print(trace)
        cproc = subprocess.run(['vvp', 'rep_tb', '+FN='+filename, '+dump='+str(int(1))],
                                stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE)
    
        pdb.set_trace()
    

if __name__ == "__main__":
    main()
