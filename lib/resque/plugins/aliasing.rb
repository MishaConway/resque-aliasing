module Resque
  module Plugins
    module Aliasing
      def alias_job klass_name
        klass = ensure_klass klass_name

        unless aliased_jobs[klass.name]
          aliased_jobs[klass.name] = 1
          klass.instance_variable_set :@queue, instance_variable_get(:@queue)
          klass.instance_variable_set :@destination, self
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
        if parent.const_defined? const_name
          const = parent.const_get const_name
          raise "expected #{const.name} to be a #{klass.name}" unless const.kind_of? Module
          const
        else
          parent.const_set const_name, klass.new
        end
      end
    end
  end
end
