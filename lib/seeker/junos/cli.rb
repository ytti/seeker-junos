require_relative '../cli'
require_relative '../junos'
module Seeker
  class JunosCLI < CLI
    def opts_parse
      opts = Slop.parse(:help=>true) do
        banner 'Usage: junos-seeker [options] hostname'
        on 'l=', 'level', 'Level to start from, e.g. chassis, system, routing-options'
        on 'd',  'debug', 'Debug (optionally with level)', :optional_argument=>true
      end
    end

    def seek
      Junos.new(@host, @user, @password, @opts).seek
    end
  end
end
