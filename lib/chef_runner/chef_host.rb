require 'sshkit'

module ChefRunner

  class ChefHost < SSHKit::Host

    attr_reader :chef

    def initialize(host_string_or_options_hash, ssh_options, chef = {})
      super(host_string_or_options_hash)
      @chef = chef
      self.ssh_options = ssh_options
    end
  end
end
