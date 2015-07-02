require 'yaml'
require 'logger'

module AutodeployBootstrap
    
  CONFIG_PARAMETERS = %w[autodeploy_script_path database_host database_user database_password database_log_level temp_dir log_level log_file environment].map(&:to_sym)
    
  CONFIG_FILE = "autodeploy_bootstrap.yml"
  config_paths = [ '/etc/' + CONFIG_FILE, File.expand_path("../../../config/#{CONFIG_FILE}", __FILE__) ]
  config_paths.insert(1, ENV['HOME'] + '/' + CONFIG_FILE) if ENV['HOME']
  config = config_paths.detect {|config| File.file?(config) }
    
  if !config
    $stderr.puts "no configuration file found in paths: " + config_paths.join(',')
    exit!
  else
    puts "using configuration file: " + config
  end
  
  config_parsed = begin
    YAML.load(File.open(config))
  rescue ArgumentError, Errno::ENOENT => e
    $stderr.puts "Exception while opening yml config file: #{e}"
    exit!
  end
  
  begin
    CONFIG = config_parsed.inject({}){|h,(k,v)| h[k.to_sym] = v; h}
  rescue NoMethodError => e
    $stderr.puts "error parsing configuration yaml"
  end
  
  missing_config = Array.new
  CONFIG_PARAMETERS.each do |key|
     missing_config << key if (CONFIG[key].nil? || CONFIG[key].empty?)
  end
  
  $LOGGER = AutodeployBootstrap::CONFIG[:log_file]  == 'STDOUT' ? Logger.new(STDOUT) : Logger.new(AutodeployBootstrap::CONFIG[:log_file], 10, 1048576)
  $LOGGER.level = Logger::module_eval(AutodeployBootstrap::CONFIG[:log_level])
  
  if !missing_config.empty?
    $LOGGER.error "no value found for required configuration parameter(s): #{missing_config.join(',')}" if (!missing_config.empty?)
    exit!
  end

end