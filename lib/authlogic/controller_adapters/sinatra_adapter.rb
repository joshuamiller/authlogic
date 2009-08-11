module Authlogic
  module ControllerAdapters
    # Adapts authlogic to work with rails. The point is to close the gap between what authlogic expects and what the rails controller object
    # provides. Similar to how ActiveRecord has an adapter for MySQL, PostgreSQL, SQLite, etc.
    class SinatraAdapter < AbstractAdapter
      
      def cookies
        request.cookies
      end
      
      # Lets Authlogic know about the controller object via a before filter, AKA "activates" authlogic.
      module SinatraImplementation
        def self.included(klass) # :nodoc:
          klass.before { activate_authlogic }
        end
        
        private
          def activate_authlogic
            Authlogic::Session::Base.controller = SinatraAdapter.new(self)
          end
      end
    end
  end
end

Sinatra::Base.send(:include, Authlogic::ControllerAdapters::SinatraAdapter::SinatraImplementation)
