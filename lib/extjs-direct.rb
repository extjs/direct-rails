#$:.unshift(File.dirname(__FILE__)) unless
#  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Rails
    module ExtJS
        module Direct
            
        end
    end
end
require File.join(File.dirname(__FILE__), 'xresponse')
require File.join(File.dirname(__FILE__), 'xrequest')
require File.join(File.dirname(__FILE__), 'xexception')
require File.join(File.dirname(__FILE__), 'rack', 'remoting_provider')
require File.join(File.dirname(__FILE__), 'mixins', 'action_controller', 'direct_controller')
require File.join(File.dirname(__FILE__), 'helpers', 'direct_controller_helper')
