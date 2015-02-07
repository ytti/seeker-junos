require_relative '../seeker'
require_relative 'ssh'

module Seeker
  class Junos
    KNOWN = %w( apply-flags apply-lock apply-macro inherit )
    CHARS = ('a'..'z').to_a + ('0'..'9').to_a + %w( - )
    REPORT_INTERVAL = 10*60
    INVALID_INTERFACES = [
      /^error: invalid interface type/,
      /^error: missing or invalid (?:device|fpc) number/,
    ]

    def seek
      @ssh = ssh_connect
      @ssh.cmd 'configure'
      start = Time.now
      @report = start+REPORT_INTERVAL
      Log.info "starting"
      seek_level @opts[:level]
      Log.info "finishing, took #{(Time.now - start)/60} minutes"
      @ssh.cmd 'rollback'
      @ssh.cmd 'exit'
      @ssh.close
      @found
    end

    def seek_level level
      @ssh.cmd 'edit ' + level if level
      @known = known_get
      find_hidden
      @ssh.cmd 'top'
    end

    private

    def find_hidden
      CHARS.each do |c|
        cmd = @cmd.join + c
        if Time.now > @report
          Log.info "now at '#{cmd}', found #{@found.size} so far"
          @report += REPORT_INTERVAL
        end
        next if @known.include? cmd
        o = @ssh.cmd 'set ' + cmd
        if complete? o
          Log.info "Found: '#{cmd}'"
          @report += REPORT_INTERVAL
          @found << cmd
        elsif valid? o
          @cmd << c
          find_hidden
          @cmd.pop
        end
      end
    end

    def valid? output
      valid = true
      output = output.split "\n"
      output = output[1..-1]
      if output[1].match(/^syntax error\./)
        output = output.first.sub(/^(\s+).*/, '\1')
        valid = false if output.size < @min_space
      end
      valid = false if INVALID_INTERFACES.any? {|re| output[0].match re}
      valid
    end

    def complete? output
      output = output.split "\n"
      output = output[1..-1]
      complete = true
      complete = false if output[1].match(/^syntax error\./)
      complete = false if output[1].match(/ is ambiguous\./)
      complete = false if output[0].match(/^error: syntax error:/)
      complete = false if INVALID_INTERFACES.any? {|re| output[0].match re}
      complete
    end

    def known_get
      o = @ssh.cmd 'set ?'
      o = o.each_line.map do |line|
        re = line.match(/^[\s>+] (\S+).*/)
        re[1] if re
      end
      o.compact + KNOWN
    end

    def initialize host, user, password, opts
      @host, @user, @password, @opts = host, user, password, opts
      @ssh       = nil
      @known     = nil
      @min_space = nil
      @report    = nil
      @cmd       = []
      @found     = []
    end

    def ssh_connect
      ssh = SSH.new @host, @user, @password
      ssh.cmd 'set cli complete-on-space off'
      ssh.cmd 'set cli screen-length 0'
      @min_space = ssh.prompt_seen.size + 5
      ssh
    end

  end
end
