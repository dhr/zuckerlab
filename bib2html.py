#!/usr/bin/env python

from __future__ import print_function
import sys
from pybtex.database.input import bibtex

parser = bibtex.Parser()
bibdata = parser.parse_file("src/pubs/zucker.bib")

def prindent(n, *s):
  for i in xrange(0, n):
    sys.stdout.write('  ')
  print(*s)

prindent(0, 'ul.publist')
for bib_id in bibdata.entries:
  prindent(1, 'li')
  b = bibdata.entries[bib_id].fields
  prindent(2, 'span.authors')
  for author in bibdata.entries[bib_id].persons['author']:
    s = ''
    if author.last():
      s += author.last()[0]
    if author.first():
      s += ', ' + author.first()[0][0] + '.'
    if author.middle():
      s += author.middle()[0][0] + '.'
    prindent(3, 'span.author', s)
  if 'title' in b:
    prindent(2, 'span.title', b['title'])
  if 'journal' in b:
    prindent(2, 'span.journal', b['journal'])
    if 'volume' in b:
      prindent(2, 'span.volume', b['volume'])
    if 'number' in b:
      prindent(2, 'span.issue', b['number'])
  elif 'booktitle' in b:
    prindent(2, 'span.booktitle', b['booktitle'])
  if 'pages' in b:
    prindent(2, 'span.pages', b['pages'])
  if 'year' in b:
    prindent(2, 'span.year', b['year'])
  print()
