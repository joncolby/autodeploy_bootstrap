require 'socket'

module AutodeployBootstrap 
  
  def self.first_private_ipv4
    Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
  end
  
  def self.first_public_ipv4
    Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?}.ip_address
  end
  
  def self.my_environment
    
    return ENV['environment'] if !ENV['environment'].nil?
    
    ip_address = first_private_ipv4
    second_octet = ip_address.split('.')[1]
    
    case second_octet
    when 38,46,47
      'Production'
    when 44
      'Integration'
    else
      'Unknown'
    end
    
  end
  
  private_class_method :first_private_ipv4, :first_public_ipv4
  
end