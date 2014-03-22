require 'logger'

module Seeker
  class SeekerError < StandardError; end
  class << self
    def debug
      @debug
    end
    def debug= arg
      @debug=arg
    end
  end
  Log = Logger.new STDOUT
  Log.level = Logger::INFO
end
