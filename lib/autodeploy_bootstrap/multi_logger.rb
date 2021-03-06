require 'logger'

module AutodeployBootstrap
  
  class MultiLogger < Logger
    def initialize(logdev, shift_age = 10, shift_size = 1048576)
       super(logdev, shift_age, shift_size)
       @stdout = nil
       if (logdev == STDOUT)
         @stdout = STDOUT
       end
     end
   
     def log(severity, message = nil, progname = nil, &block)
       msg = format_message(format_severity(severity), Time.now, progname, message)
       self<<(msg)
       if (@stdout != nil)
         @stdout.puts(msg)
       end
     end
  end
   
end