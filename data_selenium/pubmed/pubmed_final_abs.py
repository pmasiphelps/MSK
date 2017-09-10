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

#driver.get("https://www.ncbi.nlm.nih.gov/pubmed/?term=cancer+mutation/")



search1 = "(((cancer[Title/Abstract]) AND \"journal article\"[Publication Type]) AND \
(\"2000\"[Date - Publication] : \"3000\"[Date - Publication])) AND mutation[Title/Abstract]"

search2 = "((cancer[Title/Abstract] AND gene[Title/Abstract] AND mutation[Title/Abstract]) AND \
(\"2000\"[Date - Publication] : \"3000\"[Date - Publication]))" 


url = "https://www.ncbi.nlm.nih.gov/pubmed/?term=" + search2
driver.get(url)

button1 = driver.find_element_by_xpath('.//*[@class="inline_list left display_settings"]/li[1]/a/span[3]')
button1.click()
time.sleep(1)

button2 = driver.find_element_by_xpath('.//*[@id="abstract"]')
button2.click()
time.sleep(5)	

button3 = driver.find_element_by_xpath('.//*[@class="inline_list left display_settings"]/li[3]/a/span[3]')
button3.click()
time.sleep(1)

button4 = driver.find_element_by_xpath('.//*[@id="ps200"]')
button4.click()
time.sleep(15)

# driver.find_elements_by_xpath(".//input[@type='radio' and @value='SRF']")[0].click
csv_file = open('pubmed_abstract.csv', 'w')
writer = csv.writer(csv_file)
writer.writerow(['pmid', 'title', 'keywords', 'abstract', 'link'])
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
		#reviews = driver.find_elements_by_xpath('//*[@class="rprt"]')
		reviews = driver.find_elements_by_xpath('//*[@class="rprt abstract"]')

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
			title = review.find_element_by_xpath('.//*[@class="rslt"]/h1/a').text  # abstract 
			# keywords
			try:
				keywords = review.find_element_by_xpath('.//*[@class="keywords"]/p').text #abstract  
			except:
				keywords = ''  
			# abstract
			try:
				abstract = review.find_element_by_xpath('.//*[@class="abstr"]//abstracttext').text
			except:
				abstract = ''
			
			linking = 'https://www.ncbi.nlm.nih.gov/pubmed/' + pmid
			
			
			review_dict['pmid'] = pmid
			review_dict['title'] = title
			review_dict['keywords'] = keywords
			review_dict['abstract'] = abstract	
			review_dict['link'] = linking
			
			writer.writerow(review_dict.values())
			


		# Locate the next button on the page. Then call 'button.click()' to really click it.
		button = driver.find_element_by_xpath('.//*[@class="active page_link next"]')
		button.click()
		time.sleep(2)



	except Exception as e:
		print(e)
		driver.close()
		break
