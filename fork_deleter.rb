require 'octokit'

module GitHub
  class ForkDeleter
    def initialize
      # get a token from:
      #   https://github.com/settings/tokens
      #   Generate new token
      #   Give it delete_repo permissions
      @client = Octokit::Client.new(:access_token => personal_access_token)
      @client.auto_paginate = true # get them all in one call
    end

    def delete_forks!
      repos.each do |repo|
        if fork?(repo)
          puts "Deleting #{repo.name}"
          delete_fork!(repo)
        end
      end
    end

    private

    def repos
      @repos ||= @client.repos({})
    end

    def delete_fork!(repo)
      raise "#{repo.name} is a not a fork!" unless fork?(repo)

      @client.delete_repository("julio/#{repo.name}")
    end

    def fork?(repo)
      repo[:fork]
    end

    def personal_access_token
      ENV['GITHUB_ACCESS_TOKEN']
    end
  end
end

GitHub::ForkDeleter.new.delete_forks!