#!/usr/bin/python3

import sys
import gzip
import pandas as pd

in_fn = sys.argv[1]
out_fn = sys.argv[2]

print("input file:\n")
print(in_fn)
print("out file:\n")
print(out_fn)

#
# in_fn = "chr20_EAS_merged_23_array_correlation.txt.gz"
#out_fn = "chr20_EAS_merged_23_array_correlation.filtered.txt"

out_file = open(out_fn, 'w')

with gzip.open(in_fn,'rt') as f:
    for l in f:
        if l[0] == "I":
            print("header line is:\n")
            l_out = "chr" + "\t" + "pos" + "\t" + l
            print(l_out)
            continue
        tem = l.split()
        if float(tem[2]) >= 0.01:
            tem2 = tem[0].split(":")
            l_out = tem2[0] + "\t" + tem2[1] + "\t" + l
            out_file.writelines(l_out)

f.close()
out_file.close()

df = pd.read_csv(out_fn, sep = '\t', header = None)
df = df.sort_values(by=[1])
df.to_csv(out_fn, sep = "\t", index = False, header = False)