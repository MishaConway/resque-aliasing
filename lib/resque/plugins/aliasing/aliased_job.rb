module Resque
  module Plugins
    module Aliasing
      module AliasedJob
        module ClassMethods
          def before_enqueue *args
            Resque.enqueue @destination, *args
            false
          end

          def perform *args
            Resque.enqueue @destination, *args
          end
        end

        def self.included(base)
          base.extend ClassMethods
        end
      end
    end
  end
end
