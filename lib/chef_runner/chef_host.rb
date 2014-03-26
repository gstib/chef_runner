require 'sshkit'

module ChefRunner

  class ChefHost < SSHKit::Host

    attr_reader :chef

    def initialize(host_string_or_options_hash, ssh_options, chef = {})
      super(host_string_or_options_hash)
      @chef = chef
      self.ssh_options = {
          user: ssh_options[:username],
          keys: [ssh_options[:key]],
          port: ssh_options[:port] || 22,
          auth_methods: %w(publickey)
      }
    end
  end
end
