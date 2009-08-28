module Rails::ExtJS::Direct::Controller

    # standard ruby method called when some class does:
    # include Merb::ExtJS::Direct::RemotingProvider
    def self.included(base)
      base.class_eval do
        @@actions = []
        before_filter :extjs_direct_prepare_request

        # include the Helper @see helpers/direct_controller_helper.rb
        helper Helper

        def self.direct_actions(*actions)
          unless actions.empty?
            @@actions = actions.collect {|a| a.kind_of?(Hash) ? a : {:name => a, :len => 1}}
          else
            @@actions
          end
        end

        # @deprecated
        def self.get_direct_actions
          @@actions
        end
      end
    end

    def extjs_direct_prepare_request
        #TODO just populate params with the XRequest data.

        @xrequest = XRequest.new(params)
        @xresponse = XResponse.new(@xrequest)

        token = params["authenticity_token"] || nil

        params.each_key do |k|
          params.delete(k)
        end

        params["authenticity_token"] = token if token

        params[:id] = @xrequest.id

        if @xrequest.id.kind_of?(Array)
          params[:data] = @xrequest.params
        elsif @xrequest.params.kind_of?(Hash)
          params[:data] = {}
          @xrequest.params.each do |k,v|
            params[:data][k] = v
          end
        end
    end

    def respond(status, params)
      @xresponse.status = status
      @xresponse.message = params[:message] if params[:message]
      @xresponse.result = params[:result] if params[:result]

      render :json => @xresponse
    end

    def rescue_action(e)
      if (e.kind_of?(XException))
        render :json => XExceptionResponse.new(@xrequest, e)
      else
        render :json => XExceptionResponse.new(@xrequest, e)
      end
    end
end
