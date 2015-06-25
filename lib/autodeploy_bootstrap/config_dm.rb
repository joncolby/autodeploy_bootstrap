module AutodeployBootstrap
      DataMapper::Logger.new($stdout, :info)
      DataMapper.setup(:default, 'mysql://autodeploy:autodeploy@localhost/autodeploy')
end