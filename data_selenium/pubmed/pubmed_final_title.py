# Website we want to scrape is: https://www.verizonwireless.com/smartphones/samsung-galaxy-s7/
# The documentatio of selenium is here: http://selenium-python.readthedocs.io/index.html

# Please follow the instructions below to setup the environment of selenium
# Step #1
# Windows users: download the chromedriver from here: https://chromedriver.storage.googleapis.com/index.html?path=2.30/
# Mac users: Install homebrew: http://brew.sh/
#			 Then run 'brew install chromedriver' on the terminal
#
# Step #2
# Windows users: open Anaconda prompt and switch to python3 environment. Then run 'conda install -c conda-forge selenium'
# Mac users: open Terminal and switch to python3 environment. Then run 'conda install selenium'

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import Select
import time
import csv

# Windows users need to specify the path to chrome driver you just downloaded.
# driver = webdriver.Chrome('path\to\where\you\download\the\chromedriver')

driver = webdriver.Chrome()
# input the search condition
search1 = "(((cancer[Title/Abstract]) AND \"journal article\"[Publication Type]) AND \
(\"2000\"[Date - Publication] : \"3000\"[Date - Publication])) AND mutation[Title/Abstract]"

search2 = "((cancer[Title/Abstract] AND gene[Title/Abstract] AND mutation[Title/Abstract]) AND \
(\"2000\"[Date - Publication] : \"3000\"[Date - Publication]))" 

# add to the search engineer
url = "https://www.ncbi.nlm.nih.gov/pubmed/?term=" + search2
driver.get(url)

# driver.find_elements_by_xpath(".//input[@type='radio' and @value='SRF']")[0].click
csv_file = open('pubmed.csv', 'w')
writer = csv.writer(csv_file)
writer.writerow(['pmid', 'title', 'author', 'journal', 'form'])
# need to add abstract and key word before scraping the pages

# Page index used to keep track of where we are.
index = 1
while index < 3: # True
	try:
		print("Scraping Page number " + str(index))
		index = index + 1
		# Find the device name
		# Check the documentation here: http://selenium-python.readthedocs.io/locating-elements.html

		# Find all the reviews. The find_elements function will return a list of selenium select elements.
		reviews = driver.find_elements_by_xpath('//*[@class="rprt"]')

		print('=' * 50)
		print(len(reviews))
		print(reviews[0])
		print('=' * 50)



		# To test the xpath, you can comment out the following code in the try statement and print the length of reviews.
		# Iterate through the list and find the details of each review.
		for review in reviews:
			# Initialize an empty dictionary for each review
			review_dict = {}
			
			# Use Xpath to locate the title, content, username, date.
			# Once you locate the element, you can use 'element.text' to return its string.
			# To get the attribute instead of the text of each element, use 'element.get_attribute()'


			#title = review.find_element_by_xpath('.//div[@class="bv-content-title-container"]//h4').text

			pmid = review.find_element_by_xpath('.//*[@class="rprtid"]/dd').text
			title = review.find_element_by_xpath('.//*[@class="title"]/a').text
			author = review.find_element_by_xpath('.//*[@class="desc"]').text
			journal = review.find_element_by_xpath('.//*[@class="details"]/span').text
			form = review.find_element_by_xpath('.//*[@class="details"]/span').get_attribute("class")
			link = 'https://www.ncbi.nlm.nih.gov/pubmed/' + pmid

			review_dict['pmid'] = pmid
			review_dict['title'] = title	
			review_dict['author'] = author	
			review_dict['journal'] = journal	
			review_dict['form'] = form
			review_dict['link'] = link

			writer.writerow(review_dict.values())	
			

			# Your code here

		# Locate the next button on the page. Then call 'button.click()' to really click it.
		button = driver.find_element_by_xpath('.//*[@class="active page_link next"]')
		button.click()
		time.sleep(10)



	except Exception as e:
		print(e)
		driver.close()
		break
