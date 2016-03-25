module Resque
  module Plugins
    module Aliasing
      class UnexpectedConstant < ::StandardError; end;

      def alias_job klass_name
        klass_name = klass_name.name if klass_name.kind_of? Class
        klass = ensure_klass klass_name.to_s

        unless aliased_jobs[klass.name]
          aliased_jobs[klass.name] = 1
          klass.instance_variable_set :@queue, "dummy_queue"
          klass.instance_variable_set :@resque_aliasing_destination, self
          klass.include AliasedJob
        end
      end

      def aliased_jobs
        @aliased_jobs ||= {}
      end


      def ensure_klass klass_name
        segments = klass_name.split '::'
        demodulized_klass_name = segments.pop

        parent_module = Object
        while segments.size > 0
          parent_module = ensure_const parent_module, segments.shift, Module
        end

        ensure_const parent_module, demodulized_klass_name, Class
      end

      def ensure_const parent, const_name, klass
        full_const_name = const_name
        full_const_name = "#{parent.name}::#{full_const_name}" unless parent == Object

        if parent.const_defined? const_name
          const = parent.const_get const_name
          if full_const_name == const.name
            unless const.kind_of? klass
              raise UnexpectedConstant, "Expected #{full_const_name} to be a #{klass.name}"
            end
            return const
          end
        end

        parent.const_set const_name, klass.new
      end
    end
  end
end
