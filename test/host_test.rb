require 'test_helper'

class HostTest < Minitest::Test
  
  def test_find_host
    host = AutodeployBootstrap::Host.first(:name => "search46-1")
    puts host
  end
end