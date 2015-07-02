module AutodeployBootstrap    
  class Deployment
    include AutodeployBootstrap
    
    def initialize(deploy_plan)
      @deploy_plan = deploy_plan
    end
    
    def run
      executable = CONFIG[:autodeploy_script_path]
      #command = "java -jar #{executable} #{@deploy_plan}"
        # TESTING - TODO: REMOVE
      command = executable
      puts command      
      execute(command)  
    end
  end
end