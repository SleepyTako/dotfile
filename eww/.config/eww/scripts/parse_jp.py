#!/bin/python3 

import sys
# -*- coding:utf-8 -*-

ranges = [
  {"from": ord(u"\u3300"), "to": ord(u"\u33ff")},         # compatibility ideographs
  {"from": ord(u"\ufe30"), "to": ord(u"\ufe4f")},         # compatibility ideographs
  {"from": ord(u"\uf900"), "to": ord(u"\ufaff")},         # compatibility ideographs
  {"from": ord(u"\U0002F800"), "to": ord(u"\U0002fa1f")}, # compatibility ideographs
  {'from': ord(u'\u3040'), 'to': ord(u'\u309f')},         # Japanese Hiragana
  {"from": ord(u"\u30a0"), "to": ord(u"\u30ff")},         # Japanese Katakana
  {"from": ord(u"\u2e80"), "to": ord(u"\u2eff")},         # cjk radicals supplement
  {"from": ord(u"\u4e00"), "to": ord(u"\u9fff")},
  {"from": ord(u"\u3400"), "to": ord(u"\u4dbf")},
  {"from": ord(u"\U00020000"), "to": ord(u"\U0002a6df")},
  {"from": ord(u"\U0002a700"), "to": ord(u"\U0002b73f")},
  {"from": ord(u"\U0002b740"), "to": ord(u"\U0002b81f")},
  {"from": ord(u"\U0002b820"), "to": ord(u"\U0002ceaf")}  # included as of Unicode 8.0
]

def is_cjk(char):
  return any([range["from"] <= ord(char) <= range["to"] for range in ranges])

def cjk_substrings(string):
  i = 0
  while i<len(string):
    if is_cjk(string[i]):
      start = i
      try:
        while is_cjk(string[i]): i += 1
        yield string[start:i]
      except:
        yield string[start:i]
    i += 1

ogstring = str(sys.argv[1]).replace("\n", " ")
if len(ogstring) > 20:
  ogstring += "        "

scroll = int(sys.argv[2])
string = ogstring[scroll:] + ogstring[:scroll]
string = string[0:20]
string = string.replace("&", "&amp;")

for sub in cjk_substrings(string):
  string = string.replace(sub, "<span font-family= \"M PLUS 1\" font-size=\"x-small\" rise=\"3pt\" font-weight=\"bold\">" + sub + "</span>")
print(string)
