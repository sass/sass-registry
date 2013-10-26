class GitHubProject
  attr_accessor :repository_url, :username, :reponame, :info, :description, :homepage
  delegate :description, :homepage, :updated_at, :watchers, to: :info

  def initialize(url)
    @repository_url = url
    @username = url[/\:(.*?)\//, 1]
    @reponame = url[/\/(.*?).git/, 1]
  end

  def info
    @info ||= Octokit.repo("#{@username}/#{@reponame}")
  end

  def file(path)
    Octokit.contents("#{username}/#{reponame}", path: path, accept: "application/vnd.github-blob.raw")
  end
end
