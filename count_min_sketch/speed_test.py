import countminsketch
from . import count_min_sketch
from time import time
from random import randint
mytime = 0
theirtime = 0

mine = count_min_sketch.CountMinSketch(1000, 100)
theirs = countminsketch.CountMinSketch(1000, 100)

def artificial_test():
  from string import letters
  letters = letters[:26]
  to_inc = [randint(0, 1) for letter in letters]
  mytime = 0
  theirtime = 0
  
  for letter, incto in zip(letters, to_inc):

    for i in range(incto):
      t = time()
      mine.update(letter)
      mytime += time() - t
  
      t = time()
      theirs.add(letter)
      theirtime += time() - t

  for letter, should_be in zip(letters, to_inc):
    t = time()
    a = mine[letter]
    mytime += time() - t
  
    t = time()
    b = theirs[letter]
    theirtime += time() - t
  
    print(a, b, a == b, a == should_be)

  print(mytime, theirtime)
  print(theirtime / mytime)

def natural_test():
  from re import findall
  from collections import defaultdict
  from urllib.request import urlopen
  
  #Adventures of Sherlock Holmes
  filename = 'pg1661.txt'
  try:
    story = open('pg1661.txt').read()
  except:
    story = urlopen('http://www.gutenberg.org/cache/epub/1661/pg1661.txt').read()
    with open('pg1661.txt', 'w') as fd:
      fd.write(story)
  tokens = findall('[a-z]{3,}', story)
  f = defaultdict(lambda: 0)
  mytime, theirtime = 0, 0
  for token in tokens:
    f[token] += 1
  for i, (token, freq) in enumerate(iter(f.items())):
    if (i+1)%500 == 0:
      print(100.*(i+1) / len(f))
    t = time()
    mine.update(token, freq)
    mytime += time() - t
    
    t = time()
    theirs.add(token, freq)
    theirtime += time() - t
  
  loss= 0
  theirloss = 0
  for token, freq in f.items():
    theirloss += (theirs.query(token) - freq)**2
    loss += (mine.query(token) - freq)**2
  
  print('my loss:', loss**0.5 / len(f))
  print('their loss:', theirloss**0.5 / len(f))
  print(mytime, theirtime, theirtime  / mytime)

if __name__ == '__main__':
  natural_test()
  #artificial_test()
