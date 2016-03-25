module Resque
  module Plugins
    module Aliasing
      module AliasedJob
        module ClassMethods
          def before_enqueue *args
            Resque.enqueue @resque_aliasing_destination, *args
            false
          end

          def perform *args
            Resque.enqueue @resque_aliasing_destination, *args
          end
        end

        def self.included(base)
          base.extend ClassMethods
        end
      end
    end
  end
end
