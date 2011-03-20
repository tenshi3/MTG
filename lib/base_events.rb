module BaseEvents
  module ClassMethods
    def event(name, filter=[])
      filter_expand = filter.map{|m|"#{m}=nil"}.join(", ")
      self.class_eval <<-RUBY, __FILE__, (__LINE__ + 1)
        def #{name}(#{filter_expand})
          event_hooks(name).each do |hook|
            hook.fire(#{filter.join(", ")})
          end
        end
      RUBY
    end
  end
  
  module InstanceMethods
    def register(name, hook)
      @event_hooks ||= {}
      @event_hooks[name] ||= []
      @event_hooks[name] << hook
    end
    
    def event_hooks(name)
      @event_hooks ||= {}
      @event_hooks[name] ||= []
    end
  end
  
  def self.included(base)
    base.class_eval do
      extend ClassMethods
      include InstanceMethods
    end
  end
end
