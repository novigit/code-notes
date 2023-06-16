## cProfile

cProfile is python's built-in profiling tool. 
Profiling essentially means the act of measuring execution time for different sections of code

#### Simple example
```python
def function_one():
    ...

def function_two():
    ...

def main():
    a = function_one()
    b = function_two(a)

if __name__ == '__main__':
    import cProfile
    cProfile.run( "main()" )
```

This will output, *in addition to the output of the script*, a table with some functions / methods along with their execution time

```
         282973898 function calls (282973524 primitive calls) in 85.873 seconds

   Ordered by: standard name

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
        1    0.000    0.000    0.001    0.001 <frozen importlib._bootstrap>:1002(_find_and_load)
     5724    0.004    0.000    0.006    0.000 <frozen importlib._bootstrap>:1033(_handle_fromlist)
        1    0.000    0.000    0.000    0.000 <frozen importlib._bootstrap>:112(release)
        1    0.000    0.000    0.000    0.000 <frozen importlib._bootstrap>:152(__init__)
        1    0.000    0.000    0.000    0.000 <frozen importlib._bootstrap>:156(__enter__)
        1    0.000    0.000    0.000    0.000 <frozen importlib._bootstrap>:160(__exit__)
       ............................................................................................ 
       ............................................................................................ 
        1    0.013    0.013   85.872   85.872 fix_genes_with_false_introns.py:329(main)
      754    0.001    0.000    0.002    0.000 fix_genes_with_false_introns.py:357(<listcomp>)
      754    0.000    0.000    0.001    0.000 fix_genes_with_false_introns.py:358(<listcomp>)
      754    9.604    0.013   69.397    0.092 fix_genes_with_false_introns.py:54(add_rnaseq_supports)
      164    0.062    0.000   14.989    0.091 fix_genes_with_false_introns.py:94(get_region)
     2450    0.000    0.000    0.000    0.000 fractions.py:256(numerator)
     2450    0.000    0.000    0.000    0.000 fractions.py:260(denominator)
     .............................................................................................. 
     .............................................................................................. 
```

Below a quick explanation of each of the columns

```
ncalls                      - how many times the function was called
tottime                     - total time spent in this function (not including subfunctions)
percall                     - time spent in this function each time it was called (not including subfunctions)
cumtime                     - total time spent in this function (including subfunctions)
percall                     - time spent in this function each time it was called (including subfunctions)
filename:lineno(function)   - filename, line number and name of the function that was called
```

#### Command line
```sh
# -m cProfile to load the cProfile module
# NOTE: now cProfile.run() doesn't have to be invoked inside the script
python -m cProfile fix_genes_with_false_introns.py -g tiny.gff3 -b rnaseq_vs_masked_ergo_cyp_genome.sort.bam -f ergo_cyp_genome.fasta.masked -t 0.60
```

The command line version does seem to print out more, for some reason, compared to the 'within-script' version

#### Sorting the table
In both instances, the table is sorted alphabetically by the `filename:lineno(function)` column. This isn't very useful. You'll probably want to sort by
the total, cumulative amount of time per function, to see which functions are slowing down your code the most

Within your code:
```python
if __name__ == '__main__':
    import cProfile
    cProfile.run( "main()", sort='cumtime' )
```

Output:
```
         282973899 function calls (282973525 primitive calls) in 85.878 seconds

   Ordered by: cumulative time

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
      2/1    0.000    0.000   85.878   85.878 {built-in method builtins.exec}
        1    0.001    0.001   85.878   85.878 <string>:1(<module>)
        1    0.012    0.012   85.877   85.877 fix_genes_with_false_introns.py:329(main)
      754    9.752    0.013   69.537    0.092 fix_genes_with_false_introns.py:54(add_rnaseq_supports)
    75341    8.703    0.000   31.983    0.000 libcalignedsegment.pyx:2841(__get__)
 35940470   10.584    0.000   19.988    0.000 libcalignedsegment.pyx:638(makePileupRead)
      164    0.063    0.000   14.904    0.091 fix_genes_with_false_introns.py:94(get_region)
      164    0.001    0.000   11.145    0.068 File.py:224(__getitem__)
      164    0.207    0.001   11.145    0.068 _index.py:49(get)
    75775    0.044    0.000   10.757    0.000 libcalignmentfile.pyx:2716(__next__)
   120299    1.467    0.000   10.699    0.000 libcalignmentfile.pyx:2500(cnext)
     .............................................................................................. 
     .............................................................................................. 
```

It is now clear that the vast majority of the execution time is spent inside the `add_rnaseq_supports()` function. If you want to speed up your script,
this would be a good place to start optimizing your code.

Doing the same on command line:
```
python -m cProfile -s cumtime fix_genes_with_false_introns.py -g tiny.gff3 -b rnaseq_vs_masked_ergo_cyp_genome.sort.bam -f ergo_cyp_genome.fasta.masked -t 0.60
```

Output:
```
         283327565 function calls (283314784 primitive calls) in 88.098 seconds

   Ordered by: cumulative time

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
    280/1    0.001    0.000   88.098   88.098 {built-in method builtins.exec}
        1    0.001    0.001   88.098   88.098 fix_genes_with_false_introns.py:3(<module>)
        1    0.013    0.013   87.297   87.297 fix_genes_with_false_introns.py:329(main)
      754   10.015    0.013   70.513    0.094 fix_genes_with_false_introns.py:54(add_rnaseq_supports)
    75341    8.777    0.000   32.570    0.000 libcalignedsegment.pyx:2841(__get__)
 35940470   10.585    0.000   20.409    0.000 libcalignedsegment.pyx:638(makePileupRead)
      164    0.070    0.000   15.319    0.093 fix_genes_with_false_introns.py:94(get_region)
      164    0.001    0.000   11.524    0.070 File.py:224(__getitem__)
      164    0.210    0.001   11.523    0.070 _index.py:49(get)
    75775    0.045    0.000   10.766    0.000 libcalignmentfile.pyx:2716(__next__)
   120299    1.517    0.000   10.707    0.000 libcalignmentfile.pyx:2500(cnext)
     .............................................................................................. 
     .............................................................................................. 
```
