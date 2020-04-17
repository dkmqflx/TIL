import os
import requests
from bs4 import BeautifulSoup
import sys

os.system("clear")
url = "https://www.iban.com/currency-codes"

result= requests.get(url)

soup = BeautifulSoup(result.text, 'html.parser')

a = soup.find('div', {"class":"row"})

flat_services = soup.find('div', {"class":"flat-services"})

pages = soup.find('div', {"class":"flat-services"}).find("table").find('tbody').find_all('tr')

country_lst = []
for page in pages:
    country = page.find_all('td')
    #print(country)
    #print(f"name {country[0]}, code {country[2].get_text()}")
    if country[2].get_text() != '':
        name = country[0].get_text()
        code = country[2].get_text()
        name = name.capitalize()
        country_lst.append([name, code])

country_dict = {}
for lst in enumerate(country_lst):
    country_dict[lst[0]] = lst[1]

print("Hello! Please choose select a country by number:")
for i in country_dict:
    print('#',i, country_dict[i][0])

while True:
  #print("#: ")
  try: 
    number = int(input("#: "))
    if number < 0 or number >= len(country_dict):
      print('Choose a number from the list')
    else:
      print(f"You chose {country_dict[number][0]}")
      print(f"The currency code is {country_dict[number][1]}")
      break
  except ValueError:
    print("That wasn't a number.")
