require 'sshkit/dsl'
require_relative 'chef_host'

module ChefRunner
  class Bootstrap

    def initialize(params)
      @params = params
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
        execute :curl, '-L https://www.opscode.com/chef/install.sh | sudo bash'
      }
    end

  end
end