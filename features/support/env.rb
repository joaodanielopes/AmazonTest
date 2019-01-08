require 'watir-webdriver'
require 'cucumber'
require 'minitest'
require 'headless'
require 'page-object'
require 'page-object/page_factory'

World(PageObject::PageFactory)

require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'lib_require')