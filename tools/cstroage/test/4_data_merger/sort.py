#!/usr/bin/env python

import sys

if __name__ == "__main__":
  cfg = sys.argv[1]
  csvOut = sys.argv[2]

  lines = []

  for l in open(cfg).read().split("\n"):
    if len(l) == 0:
      continue

    code,csv = l.split(",")

    for line in open(csv).read().split("\n"):
      if len(line) == 0:
        continue

      record = line.split(",")
      lines.append([code] + record)

  lines.sort(key=lambda l: float(l[1])*100 + float(l[0])*0.000001)
  csv = ""
  for l in lines:
    csv += ','.join(l) + "\n"

  fout = open(csvOut, 'w')
  fout.write(csv)
  fout.close()

