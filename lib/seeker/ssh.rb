require 'net/ssh'

module Seeker
  class SSH
    TIMEOUT = 5
    PROMPT = /^[^\s>#]+[>#] /
    attr_reader :prompt_seen
    class NoSshShell < SeekerError; end

    def cmd command
      Log.debug "SSH: #{command}"
      @output = ''
      @session.send_data command + "\n"
      @session.process
      expect @prompt
      @output
    end

    def close command='exit'
      @session.send_data command +"\n"
    end

    private

    def initialize host, user, password, prompt=PROMPT
      @output      = ''
      @prompt      = prompt
      @prompt_seen = nil
      @session     = nil
      @ssh = Net::SSH.start host, user, :password=>password, :timeout=>TIMEOUT
      shell_open
    end

    def shell_open
      @session = @ssh.open_channel do |channel|
        channel.on_data do |channel, data|
          print data  if Seeker.debug > 1
          @output << data
        end
        channel.request_pty do |channel, success|
          raise NoSshShell, "Can't get PTY" unless success
          channel.send_channel_request 'shell' do |channel, success|
            raise NoSshShell, "Can't get shell" unless success
          end
        end
      end
    end

    def expect regexp
      Timeout::timeout(TIMEOUT) do
        @ssh.loop(0.1) do
          sleep 0.1
          re = @output.match regexp
          @prompt_seen = re[0] if re
          not re
        end
      end
    end


  end
end
