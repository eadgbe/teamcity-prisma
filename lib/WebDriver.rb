@@client = Selenium::WebDriver::Remote::Http::Default.new
@@client.timeout = 240 # seconds
@@driver = Selenium::WebDriver.for(:firefox, :http_client => @@client)
@@driver.manage.timeouts.implicit_wait = 60 # seconds
