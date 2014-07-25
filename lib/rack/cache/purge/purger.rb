require 'rack/cache/key'
require 'rack/mock'

module Rack
  module Cache
    class Purge
      class Purger
        attr_reader :env

        def initialize(env)
          @env = env
        end

        def purge(uris)
	  message = []
          normalize_uris(uris).map do |uri|
            stripped_uri = uri.sub /^\/*/, ''
	    message.push purgeDevice(stripped_uri, "desktop")
	    message.push purgeDevice(stripped_uri, "mobile")
	  end
	  [200, {}, message]
        end

        protected
	
	  def purgeDevice(uri, device)
	    key = key_for(uri, {"mobvious.device_type" => device})
	    metastore.purge(key)
	    entitystore.purge(key)
	    "purging #{uri} for #{device} devices\n"
	  end
	  
          def normalize_uris(uris)
            uris.split(",")
          end

          def key_for(uri,opt)
            Rack::Cache::Key.call(Rack::Cache::Request.new(env_for(uri, opt)))
          end

          def env_for(*args)
            Rack::MockRequest.env_for(*args)
          end
        
          def metastore
            @metastore ||= Rack::Cache::Storage.instance.resolve_metastore_uri(env['rack-cache.metastore'])
          end
        
          def entitystore
            @entitystore ||= Rack::Cache::Storage.instance.resolve_entitystore_uri(env['rack-cache.entitystore'])
          end
      end

      include Base
    end
  end
end