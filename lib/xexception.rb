##
# XException
# General exception class for all Ext application exceptions.
# @author Chris Scott
#
class XException < StandardError
end

##
# XExceptionResponse
# A special extension of XResponse for returning responses where an Exception was raised.  includes a back-trace in the response which
# should probably be turned on with a debug switch only.
# @author Chris Scott
#
class XExceptionResponse < XResponse
    attr_accessor :where

    ##
    # initialize
    # @param {XRequest}
    # @param {StandardError}
    #
    def initialize(req, e)
        super(req)
        @type       = 'exception'
        @message    = e.message
        @where      = e.backtrace
    end

    def to_h
        data = super
        data[:type]     = 'exception'
        data[:where]    = @where.join("\n")
        data
    end
end