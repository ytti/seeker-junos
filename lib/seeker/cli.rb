require_relative '../seeker'
require 'slop'
require 'net/netrc'

module Seeker
  class CLI
    NETRC_MACHINE = 'Seeker'
    attr_reader :result
    class NoAuthFound < SeekerError; end
    class MissingHost < SeekerError; end

    private
    def initialize
      @opts = opts_parse
      if not @opts.present? :debug
        Seeker.debug = 0
      elsif @opts[:debug]
        Seeker.debug = @opts[:debug].to_i
      else
        Seeker.debug = 1
      end
      Log.level = Logger::DEBUG if Seeker.debug > 0
      args = @opts.parse
      @host = args.first
      raise MissingHost, 'no host given as argument' unless @host
      @user, @password = netrc_get
      @result = seek
    end

    def netrc_get machine=NETRC_MACHINE
      auth = Net::Netrc.locate machine
      [auth.login, auth.password] rescue raise NoAuthFound, "could not find authentication for #{machine} in .netrc"
    end
  end
end
