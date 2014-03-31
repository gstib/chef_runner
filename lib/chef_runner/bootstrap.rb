require 'sshkit/dsl'
require_relative 'chef_host'

module ChefRunner
  class Bootstrap

    def initialize(params, force = false)
      @params = params
      @force = force
    end

    def run
      bootstrap_hosts(create_hosts)
    end

    private

    def create_hosts
      @params[:servers].collect { |server|
        ChefHost.new(server[:host], @params[:ssh])
      }
    end

    def bootstrap_hosts(hosts)
      on(hosts) {
        install = @force || !Bootstrap.chef_installed?(self)
        execute :curl, '-L https://www.opscode.com/chef/install.sh | sudo bash' if install
      }
    end

    def self.chef_installed?(backend)
      backend.test 'chef-solo'.to_sym, '-v'
    end

  end
end