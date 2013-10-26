require 'test_helper'

class GitHubProjectTest < ActionView::TestCase

  test 'it should parse ssh url' do
    project = create('git@github.com:jlong/my-sass-ext.git')
    assert_equal "jlong", project.username
    assert_equal "my-sass-ext", project.reponame
    assert_equal "git@github.com:jlong/my-sass-ext.git", project.repository_url
  end

  def create(*args)
    GitHubProject.new(*args)
  end

end
