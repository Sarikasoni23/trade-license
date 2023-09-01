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
    puts name.text

    full_address = wait.until {
      driver.find_element(:id, "address")
    }
    puts full_address.text

    current_status = wait.until {
      driver.find_element(class: "label-success")
    }
    puts current_status.text

    valid_till = wait.until {
      driver.find_element(class: "label-danger")
    }
    puts valid_till.text

    details = wait.until {
      driver.find_element(class: "establishment-meta")
    }
    puts details.text

    scraped_data = {
      name: name.text,
      full_address: full_address.text,
      current_status: current_status.text,
      valid_till: valid_till.text,
      details: details.text
    }

    scraped_data
  end
end
