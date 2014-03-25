require 'sshkit'

module ChefRunner

  class ChefHost < SSHKit::Host

    attr_reader :server

    def initialize(host_string_or_options_hash, server, ssh_options)
      super(host_string_or_options_hash)
      @server = server
      self.ssh_options = {
          user: ssh_options['username'],
          keys: [ssh_options['key']],
          port: ssh_options['port'],
          auth_methods: %w(publickey)
      }

    end
  end
end
