require 'data_mapper'

module AutodeployBootstrap 
  
  class Environment
    include DataMapper::Resource    
    storage_names[:default] = "environment"
    property :id, Serial
    property :name, String
    property :repository_id, Integer
    property :property_assembler_id, Integer
    has n, :hosts
    has 1, :repo, :parent_key => [ :repository_id ], :child_key => [ :id ]
    has 1, :property_assembler, :parent_key => [ :property_assembler_id ], :child_key => [ :id ]

    def to_s
      name
    end
  end 
  
  class Platform
    include DataMapper::Resource    
    storage_names[:default] = "platform"
    property :id, Serial
    property :name, String
    
    def to_s
      name
    end
  end
  
  class PropertyAssembler
    include DataMapper::Resource    
    storage_names[:default] = "property_assembler"
    property :id, Serial
    property :config_assembler_url, String
    property :name, String  
    
    def to_s 
      name
    end  
  end
  
  class Repo
    include DataMapper::Resource    
    storage_names[:default] = "repository"
    property :id, Serial
    property :base_url, String
    property :name, String
    property :type, String

    def to_s
      base_url
    end     
  end
  
  class Host
    include DataMapper::Resource    
    storage_names[:default] = "host"
    property :id, Serial
    property :class_name_id, Integer
    property :environment_id, Integer
    property :name, String     
    has 1, :host_class, :parent_key => [ :class_name_id ], :child_key => [ :id ]
    belongs_to :environment, 'Environment' 
      
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
    property :alias, String
    property :artifact_id, String  
    property :assemble_properties, Boolean
    property :context, String
    property :group_id, String 
    property :install_dir, String
    property :instance_properties, Boolean
    property :pillar_id, Integer
    property :release_infojmxattribute, String
    property :release_infojmxbean, String
    property :start_on_deploy, Boolean
    property :type, String
    property :modulename, String
    property :balancer_type, String
    property :start_stop_script, String
    property :market_place, String
    property :do_probe, Boolean
    property :download_name, String
    property :properties_path, String
    property :test_urls, String
    property :verificationjmxattribute, String
    property :verificationjmxbean, String
    property :probe_basic_auth_password, String
    property :probe_basic_auth_user, String
    property :probe_auth_method, String
    property :probe_auth_password, String
    property :probe_auth_user, String
    property :symlink, String
    has n, :host_class_application 
    has n, :host_classes, :through => :host_class_application
    has 1, :pillar, :parent_key => [ :pillar_id ], :child_key => [ :id ]

    def to_s
      filename
    end
    
    def suffix
      filename[filename.rindex('.') + 1, filename.length]
    end
    
    def name
      filename
    end
  end
  
  class Pillar
    include DataMapper::Resource    
    storage_names[:default] = "pillar"
    property :id, Serial
    property :name, String
    
    def to_s
      name
    end
  end
  
  class HostClassApplication
    include DataMapper::Resource    
    storage_names[:default] = "host_class_applications"
    property :host_class_id, Integer, :key => true
    property :application_id, Integer, :key => true    
    belongs_to :application, 'Application', :key => true
    belongs_to :host_class, 'HostClass', :key => true    
  end
  
  class ApplicationVersion
    include DataMapper::Resource    
    storage_names[:default] = "application_version"
    property :id, Serial
    property :application_id, Integer
    property :revision, String
  end
  
  DataMapper.finalize
end