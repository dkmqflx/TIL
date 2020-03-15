import requests
from bs4 import BeautifulSoup # 

LIMIT = 50
URL = f"https://www.indeed.com/jobs?q=python&limit={LIMIT}"

def get_last_pages():    
    result = requests.get(URL)
    
    soup = BeautifulSoup(result.text, 'html.parser') # data extracter
    pagination = soup.find("div", {"class": "pagination"})
    links = pagination.find_all('a')
    
    pages = []
    for link in links[0:-1]:
        pages.append(int(link.string)) # int로 string을 바꾸어 준다 
        
    max_page = pages[-1]
    return max_page

def extract_job(html):
    title = html.find("div", {"class": "title"}).find("a")["title"] # a 태그 안에 있는 title이라는 attribute를 가져 온다 
    company = html.find("span", {"class": "company"})
    
    if company:
      company_anchor = company.find("a")

      if company_anchor is not None:
          company = str(company_anchor.string)
      else:
          company = str(company.string)
      
      company = company.strip()
    else:
      company = None
    location = html.find("div", {"class": "recJobLoc"})["data-rc-loc"]
    
    job_id = html["data-jk"] # html이 div이므로 

    return {'title': title, 'company':company, 'location':location,
    'link':f"https://www.indeed.com/viewjob?jk={job_id}"}


def extract_jobs(last_page):

  jobs = []
    
  for page in range(last_page):
    print(f"Scrapping Indeed: page {page}") # f 문자열 포매팅
    results = requests.get(f"{URL}&start={page*LIMIT}")
      
    soup = BeautifulSoup(results.text, 'html.parser')
    results = soup.find_all("div", {"class": "jobsearch-SerpJobCard"})

    for result in results:
      job = extract_job(result) # result가 html을 담고 있다 
      jobs.append(job)
  return jobs

def get_jobs():
  last_page = get_last_pages()
  jobs = extract_jobs(last_page)
  #jobs = extract_jobs(2)

  return jobs