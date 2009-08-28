###
# XRequest
# A standard response class suitable for Ext.Direct requests.
# @author Chris Scott
#
class XRequest
    attr_reader :id, :tid, :controller, :action, :type, :params

    def initialize(params)
        # TODO: simply setting @id, @params
        @id         = (params["id"].to_i > 0) ? params["id"].to_i : (params["data"].kind_of?(Array) && (params["data"].first.kind_of?(Integer) || params["data"].first.nil?)) ? params["data"].shift : nil
        @tid        = params["tid"]
        @type       = params["type"]
        @params     = (params["data"].kind_of?(Array) && params["data"].length == 1 && params["data"].first.kind_of?(Hash)) ? params["data"].first : params["data"] || []
        @controller = params["xcontroller"]
        @action     = params["xaction"]
    end

    ##
    # arg
    # return a request argument at index.  can be used to access either [] or {}
    # @param {String/Integer} index
    # @raises XException if params doesn't exist.
    #
    def arg(index)
        if params[index].nil?
            raise XException.new("Attempt to access unknown request argument '#{index.to_s}' on transaction #{@tid}")
        end
        @params[index]
    end
end
