module Rails::ExtJS::Direct::Controller::Helper
  def get_extjs_direct_provider(type, url=nil)
    @providers = {} if @providers.nil?

    if @providers[type].nil?
      begin
        @providers[type] = "Rails::ExtJS::Direct::#{type.capitalize}Provider".constantize.new(type, url)
      rescue NameError
        raise StandardError.new("Unknown Direct Provider '#{type}'")
      end
    end
    @providers[type]
  end
end