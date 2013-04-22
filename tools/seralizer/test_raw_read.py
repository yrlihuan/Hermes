#!/usr/bin/env python
import os
import os.path

root = 'minute.sh2'

def parse_line(l):
  parts = l.split(',')
  return [parts[0],float(parts[1]),float(parts[2])]

cnt = 0.0
for code in os.listdir(root):
  d = os.path.join(root, code)
  for basename in os.listdir(d):
    fullname = os.path.join(d, basename)
    f = open(fullname)

    while True:
      l = f.readline()
      if not l:
        break

      parts = parse_line(l)
      cnt += parts[1] + parts[2]


print cnt

