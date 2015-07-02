require 'socket'
require 'open3'

module AutodeployBootstrap 
  
  def self.first_private_ipv4
    Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
  end
  
  def self.first_public_ipv4
    Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast? and !intf.ipv4_private?}.ip_address
  end
  
  def self.my_environment   
    return CONFIG[:environment] if !CONFIG[:environment].nil?
          
    ip_address = first_private_ipv4
    second_octet = ip_address.split('.')[1]    
    case second_octet
    when 38,46,47
      'Production'
    when 44
      'Integration'
    else
      raise StandardError, "Could not determine this node's environment based on IP pattern #{ip_address}. Hint: override environment discovery via command line option -e.", caller
    end    
  end
  
  def execute(command)
    error  = ""
    output = ""
    exit_status = nil
    begin
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|        
        exit_status = wait_thr.value
        while line = stderr.gets
          if line.strip.length > 0
            error << line
          end
        end      
          
        while line = stdout.gets
          if line.strip.length > 0          
            output << line
          end
        end        
      end

    rescue Errno::ENOENT => e
      raise e, "error running command: #{e.message}", caller      
    end
    
    return { :output => output, :error => error, :exit_status => exit_status.exitstatus } 
      
  end
  
  private_class_method :first_private_ipv4, :first_public_ipv4
  
end