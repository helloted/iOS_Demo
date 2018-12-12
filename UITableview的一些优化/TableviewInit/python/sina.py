
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup

CHROME_PATH = "/Users/imac/webdriver/chromedriver"
import time


def get_sina():
    driver = webdriver.Chrome(executable_path=CHROME_PATH)
    driver.delete_all_cookies()
    driver.get('https://weibo.com/')
    time.sleep(10)
    # print driver.page_source
    soup = BeautifulSoup(driver.page_source, 'html.parser')
    print '==============================================='
    for content in soup.find_all(class_='UG_list_a'):
        print content
    #     print content.text.strip()
    #     success = True
    # print url + ' -->' + str(success)
    # # print
    # # lis = driver.find_element_by_class_name('UG_list_a')


if __name__ == '__main__':
    get_sina()