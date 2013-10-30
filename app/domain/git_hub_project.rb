class GitHubProject
  attr_accessor :repository_url, :username, :reponame, :info, :description, :homepage
  delegate :description, :homepage, :updated_at, :watchers, to: :info

  def initialize(url)
    if %r{github\.com[:/](.+?)/(.+?)(?:\.git|)$}i.match(url.strip)
      @username = $1
      @reponame = $2
      @repository_url = "git@github.com:#{username}/#{reponame}.git"
    end
  end

  def info
    @info ||= Octokit.repo("#{@username}/#{@reponame}")
  end

  def file(path)
    Octokit.contents("#{username}/#{reponame}", path: path, accept: "application/vnd.github-blob.raw")
  end
end
