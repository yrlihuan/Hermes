#!/usr/bin/env python
import os
import os.path
import time
import cPickle as pkl
import numpy

root = 'minute.sh2'
target = 'minute.numpy.npz'

def parse_line(l):
  parts = l.split(',')

  t = time.strptime(parts[0], "%Y/%m/%d %H:%M:%S")
  t = time.mktime(t)
  return [t,float(parts[1]),float(parts[2]),int(parts[3])]

for code in os.listdir(root):
  d = os.path.join(root, code)
  td = os.path.join(target, code)

  if not os.path.exists(td):
    os.system("mkdir -p %s" % td)

  for basename in os.listdir(d):
    fullname = os.path.join(d, basename)
    f = open(fullname)

    records = []
    while True:
      l = f.readline()
      if not l:
        break

      parts = parse_line(l)
      records.append(parts)

    f.close()

    records = numpy.array(records)
    out = os.path.join(td, basename)
    out = out[:-3] + "npz"

    numpy.savez(out, data=records)

