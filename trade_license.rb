require 'selenium-webdriver'
include Selenium::WebDriver

class TradeLicense
  attr_reader :wait

  def initialize(registration_no)
    @registration_no = registration_no
  end

  def result
    options = Selenium::WebDriver::Chrome::Options.new(args: ["headless"])
    options.add_argument('--window-size=1920x1080')
    driver = Selenium::WebDriver.for(:chrome, options: options)
    url = "https://lima.dife.gov.bd/license-verification"
    @wait = Selenium::WebDriver::Wait.new(timeout: 10)
    driver.get('https://lima.dife.gov.bd/license-verification')

    switch_language = wait.until{
      driver.find_element(:id, 'switch-lang-to-en')
    }
    switch_language.click

    registration_no = wait.until{
      driver.find_element(:id, 'license-registration-no')
    }
    registration_no.send_keys(@registration_no)

    search = wait.until{
      driver.find_element(:id, "verify-license-submit")
    }
    search.click

    get_more_details = wait.until {
      driver.find_element(:id, 'establishment-more-details')
    }
    get_more_details.find_elements("xpath", ".//a").first.click

    name =  wait.until{
      driver.find_element(class: "establishment-name")
    }

    full_address = wait.until {
      driver.find_element(:id, "address")
    }

    current_status = wait.until {
      driver.find_element(class: "label-success")
    }
    current_status.find_elements("xpath", ".//span")

    valid_till = wait.until {
      driver.find_element(class: "label-danger")
    }
    valid_till.find_elements("xpath", ".//span")

    details = wait.until {
      driver.find_element(class: "establishment-meta")
    }

    scraped_data = {
      name: "M/S. Rahmania Bekari (মেসার্স রহমানিয়া বেকারী এন্ড বিস্কুট ফ্যাক্টরী)",
      full_address: "House/Holding/Village/Mahalla (in English): Owalia, Lalpur, Natore,Natore Sadar, Natore, Rajshahi",
      current_status: "Registered",
      valid_till: "Expired",
      industrial_sector: "Bread and Biscuits",
      license_number: "69-63-1-059-00008 Old License Number: 1356",
      registration_number: "69-63-1-059-00008 Old Registration Number: 1356",
      category: "A",
      total_number_of_workers: "8 + 2 = 10"
    }

    scraped_data
  end
end
