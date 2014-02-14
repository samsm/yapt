module Yapt
  class GitView < View
    def initialize(git_commit)
      @commit = git_commit
    end
  end
end
