#!/usr/bin/env python

import sys

if __name__ == "__main__":
  if len(sys.argv) != 3:
    print "Usage:"
    print "  python compare.py file1 file2"

  path1 = sys.argv[1]
  path2 = sys.argv[2]

  f1 = open(path1).read().rstrip()
  f2 = open(path2).read().rstrip()

  f1lines = f1.split("\n")
  f2lines = f2.split("\n")

  if len(f1lines) != len(f2lines):
    print "files diff in number of records. %s: %d; %s: %d" % (path1, len(f1lines), path2, len(f2lines))
    sys.exit(1)

  num_of_unmatches = 0
  for i in xrange(len(f1lines)):
    l1 = f1lines[i].split(",")
    l2 = f2lines[i].split(",")

    for j in xrange(len(l1)):
      p1 = l1[j]
      p2 = l2[j]

      unmatch = False
      try:
        if p1 == p2 or float(p1) == float(p2):
          continue

        unmatch = True
      except:
        unmatch = True

      if unmatch:
        num_of_unmatches += 1
        print "line %d doesn't match. %s, %s" % (i+1,p1,p2)
        sys.exit(1)

  if num_of_unmatches:
    print "%d unmatches found!" % num_of_unmatches
  else:
    print "files match!"


