#!/usr/bin/env python

from __future__ import print_function
import sys
import os
from pybtex.database.input import bibtex

parser = bibtex.Parser()
bibdata = parser.parse_file(sys.argv[1])

def prindent(n, *s):
  for i in xrange(0, n):
    sys.stdout.write('  ')
  print(*s)

get_year = lambda entry: entry.fields['year']
sorted_entries = sorted(
  bibdata.entries.values(),
  key=get_year,
  reverse=True)

kind = os.path.splitext(os.path.basename(sys.argv[1]))[0]
prindent(0, 'ul.publist.' + kind)
for entry in sorted_entries:
  prindent(1, 'li.' + kind[:-1])
  b = entry.fields
  prindent(2, 'span.reference')
  prindent(3, 'span.authors')
  for author in entry.persons['author']:
    s = ''
    if author.last():
      s += author.last()[0]
    if author.first():
      s += ', ' + author.first()[0][0] + '.'
    if author.middle():
      s += author.middle()[0][0] + '.'
    prindent(4, 'span.author', s)
  if 'title' in b:
    prindent(3, 'span.title', b['title'])
  if 'journal' in b:
    prindent(3, 'span.journal', b['journal'])
    if 'volume' in b:
      prindent(3, 'span.volume', b['volume'])
    if 'number' in b:
      prindent(3, 'span.issue', b['number'])
  elif 'booktitle' in b:
    prindent(3, 'span.booktitle', b['booktitle'])
  if 'pages' in b:
    prindent(3, 'span.pages', b['pages'])
  if 'year' in b:
    prindent(3, 'span.year', b['year'])
  print()
