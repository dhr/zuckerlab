#!/usr/bin/env python

from __future__ import print_function
import sys
from pybtex.database.input import bibtex

parser = bibtex.Parser()
bibdata = parser.parse_file("src/pubs/book.bib")

def prindent(n, *s):
  for i in xrange(0, n):
    sys.stdout.write('  ')
  print(*s)

get_year = lambda entry: entry.fields['year']
sorted_entries = sorted(
  bibdata.entries.values(),
  key=get_year,
  reverse=True)

prindent(0, 'ul.publist')
for entry in sorted_entries:
  prindent(1, 'li')
  b = entry.fields
  prindent(2, 'span.authors')
  for author in entry.persons['author']:
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
