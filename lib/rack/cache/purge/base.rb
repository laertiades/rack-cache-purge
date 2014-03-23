module Rack
  module Cache
    class Purge
      module Base
        attr_reader :app, :purger

        def initialize(app, purge_header)
          @app = app
	  @purge_header = purge_header
        end

        def call(env)
	  if env[@purge_header].blank?
            @app.call(env)
	  else
            purger = Purger.new(env)
            purger.purge(env[@purge_header])
	  end
        end
      end
    end
  end
end