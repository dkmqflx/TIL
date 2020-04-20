import os
import csv
import requests
from bs4 import BeautifulSoup

os.system("clear")
alba_url = "http://www.alba.co.kr"

result = requests.get(alba_url)
soup = BeautifulSoup(result.text, 'html.parser')
brand_lst = soup.find('div', {'id':'MainSuperBrand'}).find('ul', {'class':'goodsBox'}).find_all('li')

url_lst = []
for brands in brand_lst:
    url = brands.find('a')['href']
    if 'http://' in url:
        company_name = brands.find('img')['alt']
        url_lst.append([url, company_name])

def select_company(url): # select company that has more than 0 jobs
    result_url = requests.get(url)
    soup_url = BeautifulSoup(result_url.text, 'html.parser')
    count_check = soup_url.find('p', {'class':["listCount",'jobCount']}).find('strong').text

    if count_check != '0':
        company = soup_url.find('div', {'class' : 'goodsList goodsJob'}).find('tbody').find_all('tr', {'class' : ["", "divide"]})
        return company

def extract_job(company): # extract jobs of the company
    job_lst = []
    for i in range(len(company)):
        
        info_dic = {}
        area = company[i].find('td', {'class':'local first'}).get_text()
        area = area.replace('\xa0', ' ')
        comp_area = company[i].find('td', {'class':'title'}).find('span').get_text().strip()
        time = company[i].find('td', {'class':'data'}).get_text()
        salary = company[i].find('td', {'class':'pay'}).get_text()
        reg_time= company[i].find('td', {'class':'regDate last'}).get_text()

        info_dic['area'] = area
        info_dic['comp_area'] = comp_area
        info_dic['time'] = time
        info_dic['salary'] = salary
        info_dic['reg_time'] = reg_time
        
        job_lst.append(info_dic)
  
    return job_lst
            
def save_to_file(jobs, filename):
    file = open(f"{filename}.csv", mode = "w", encoding='utf-8')
    writer = csv.writer(file)
    writer.writerow(["place","title","time","pay","date"])
    
    for job in jobs:
        writer.writerow(list(job.values()))
    return

for url in url_lst:
    company = select_company(url[0])
    print(f"{url[1]} is start")
    if company :
        jobs = extract_job(company)
        save_to_file(jobs, url[1])
        print(f"{url[1]} is done")