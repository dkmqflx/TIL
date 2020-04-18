import os
import requests
from bs4 import BeautifulSoup
from babel.numbers import format_currency

os.system("clear")

"""
Use the 'format_currency' function to format the output of the conversion
format_currency(AMOUNT, CURRENCY_CODE, locale="ko_KR" (no need to change this one))
"""

#print(format_currency(5000, "KRW", locale="ko_KR"))
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

print("Welcome to CurrencyConvert PRO2000")
for i in country_dict:
    print('#',i, country_dict[i][0])

print("\n")
print("Where are you from? Choose a country by number.\n")

country1_num = int(input("#: "))
print(f"{country_dict[country1_num][0]}\n")
country1 = country_dict[country1_num][1]


print("Now Choose another country.\n")
country2_num = int(input("#: "))
print(f"{country_dict[country2_num][0]}\n")
country2 = country_dict[country2_num][1]


while True:
  print(f"How many {country1} do you want to convert to {country2}") 

  try: 
    amount = int(input())
    break
  except ValueError:
    print("That wasn't a number.\n")


currency_url = f"https://transferwise.com/gb/currency-converter/{country1.lower()}-to-{country2.lower()}-rate?amount={amount}"
currency_result= requests.get(currency_url)

currency_soup = BeautifulSoup(currency_result.text, 'html.parser')
currency_col = currency_soup.find_all('div', {"class":"col-xs-7 col-lg-3"})

for val in currency_col:
    if val.find('label')['for'] == 'cc-amount-to':
        result = val.find('input')['value']

result_currency = format_currency(result, country2, locale="ko_KR")

print(f"{country1} {amount} is {result_currency}")