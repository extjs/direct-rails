###
# XResponse
# A standard response class suitable for Ext.Direct AJAX responses.
# @author Chris Scott
#
class XResponse
    attr_accessor :type, :status, :errors, :success, :message, :result
    attr_reader :tid

    def initialize(req)
        if req.kind_of?(XRequest)
          @tid    = req.tid
          @type   = req.type
        else
          req.kind_of?(Hash)
          @tid = req["tid"]
          @type = req["type"]
        end
        @status = false
        @message = ''
        @result = []
        @errors = []
    end

    def to_h
        {:tid => @tid, :status => @status, :type => @type, :message => @message, :result => @result, :errors => @errors}
    end

    def to_json(*params)
        self.to_h.to_json
    end
end
