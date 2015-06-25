require 'data_mapper'


DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'mysql://autodeploy:autodeploy@localhost/autodeploy')


class Host
  include DataMapper::Resource
  
  storage_names[:default] = "host"
   
  property :id, Serial
  property :class_name_id, Integer
  property :environment_id, Integer
  property :name, String 
  
  has 1, :host_class, :parent_key => [ :class_name_id ], :child_key => [ :id ] 
    
  def host_class_name
    host_class
  end
  
  def host_class_id
    class_name_id
  end
  
  def to_s
    name
  end
  
end

class HostClass
  include DataMapper::Resource
  
  storage_names[:default] = "host_class"
    
  property :id, Serial
  property :name, String
  
  has n, :host_class_application 
  has n, :applications, :through => :host_class_application

  def to_s
    name
  end  
end


class Application
  include DataMapper::Resource
  
  storage_names[:default] = "application"   
  property :id, Serial
  property :filename, String
  
  has n, :host_class_application 
  has n, :host_classes, :through => :host_class_application
  
  def to_s
    filename
  end
end

class HostClassApplication
  include DataMapper::Resource
  
  storage_names[:default] = "host_class_applications"
  property :host_class_id, Integer, :key => true
  property :application_id, Integer, :key => true
  
  belongs_to :application, 'Application', :key => true
  belongs_to :host_class, 'HostClass', key => true
  
end

DataMapper.finalize

host = Host.first(:name => "reaper47-2")

abort "no host found for #{testhost}" if (host.nil?)

puts host
puts host.host_class_name
puts host.host_class_id

app = Application.get(32)

hc = HostClass.get(host.host_class_id)

x = HostClassApplication.all(:host_class => hc)

x.each do |w|
  puts w.application
  
end


