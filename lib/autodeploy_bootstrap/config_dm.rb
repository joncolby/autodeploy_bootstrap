require 'data_mapper'

module AutodeployBootstrap
      DataMapper::Logger.new($stdout,AutodeployBootstrap::CONFIG[:database_log_level])
      DataMapper.setup(:default, "mysql://#{AutodeployBootstrap::CONFIG[:database_user]}:#{AutodeployBootstrap::CONFIG[:database_password]}@#{CONFIG[:database_host]}/#{CONFIG[:database_name]}")
end