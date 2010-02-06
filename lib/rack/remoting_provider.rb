
class Rails::ExtJS::Direct::RemotingProvider
    def initialize(app, rpath)
        if app.kind_of?(String)
          @controllers = {}
          @type = app
        else
          @app = app
        end
        @router_path = rpath
    end

    def add_controller(controller_name)
      @controllers[controller_name.capitalize] = "#{controller_name.capitalize}Controller".constantize.get_direct_actions
    end

    def render
      "<script>Ext.Direct.addProvider({type: '#{@type}', url: '#{@router_path}', actions: #{@controllers.to_json}});</script>"
    end

    def call(env)
        
        
        if env["PATH_INFO"].match("^"+@router_path)
            output = []
            
            # Rails3 changed where request params are located:
            #     Rails 2.3.x:     action_controller.request.request_parameters
            #     Rails 3.x:       action_dispatch.request.request_parameters
            #
            params_key = env["action_controller.request.request_parameters"] ? "action_controller.request.request_parameters" : "action_dispatch.request.request_parameters"
            parse(env[params_key]).each do |req|
              # have to dup the env for each request
              request_env = env.dup

              # pop poorly-named Ext.Direct routing-params off.
              controller = req.delete("action").downcase
              action =  req.delete("method")

              # set env URI and PATH_INFO for each request
              request_env["PATH_INFO"] = "/#{controller}/#{action}"
              request_env["REQUEST_URI"] = "/#{controller}/#{action}"

              # set request params
              request_env[params_key] = req

              # call the app!
              # TODO Implement begin/rescue to catch XExceptions
              status, headers, response = @app.call(request_env)
              output << response.body
            end
            # join all responses together
            res = output.join(',')

            # [wrap in array] if multiple responses.  Each controller response will have returned json already
            # so we don't want to re-encode.
            res = "[" + res + "]" if output.length > 1

            # return response
            [200, {"Content-Type" => "text/html"}, [res]]
        else
            @app.call(env)
        end
    end

    def parse(data)
        return (data["_json"]) ? data["_json"] : [data]
    end

end

