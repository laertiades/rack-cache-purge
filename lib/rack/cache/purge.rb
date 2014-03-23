module Rack
  module Cache
    class Purge
      autoload :Base,   'rack/cache/purge/base'
      autoload :Purger, 'rack/cache/purge/purger'
      include Base
    end
  end
end