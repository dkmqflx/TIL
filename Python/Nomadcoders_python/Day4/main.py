import requests
import os
import sys


while True:
  print("Please wirte a URL or URLs you want to check. (separated by comma")
  lst = list(sys.stdin.readline().split(','))
  for url in lst:
    url = url.strip()
    if url.find('.com') != -1:
      if url.find('http://') == -1:
        url = 'http://' + url 
      try:
        result = requests.get(url)
        if result.status_code == 200:
          print(f"{url} is up!")
      except:
        print(f"{url} is down!")
    else:
      print(f"{url} is not valid")

  while True:
    print("Do you want to start over: ? [y/n]")
    response = sys.stdin.readline().split()
    response = response[0]
    if response == 'n':
      sys.exit()
    elif response == 'y':
      break
    else:
      print("That's not valid answer")
      continue
  

