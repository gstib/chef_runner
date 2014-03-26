require_relative 'chef_runner/bootstrap'
require_relative 'chef_runner/solo'

module ChefRunner
  extend self

  class << self

    def bootstrap(params)
      ChefRunner::Bootstrap.new(params).run
    end

    def solo params
      ChefRunner::Solo.new(params).run
    end

  end
end

