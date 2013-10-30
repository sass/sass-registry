require 'test_helper'

class GitHubProjectTest < ActionView::TestCase

  test 'it should parse SSH url' do
    project = create('git@github.com:jlong/my-sass-ext.git')
    assert_equal "jlong", project.username
    assert_equal "my-sass-ext", project.reponame
    assert_equal "git@github.com:jlong/my-sass-ext.git", project.repository_url
  end

  test 'it should parse http url' do
    project = create('http://github.com/jlong/my-sass-ext')
    assert_equal "jlong", project.username
    assert_equal "my-sass-ext", project.reponame
    assert_equal "git@github.com:jlong/my-sass-ext.git", project.repository_url
  end

  test 'it should parse https url' do
    project = create('https://github.com/jlong/my-sass-ext')
    assert_equal "jlong", project.username
    assert_equal "my-sass-ext", project.reponame
    assert_equal "git@github.com:jlong/my-sass-ext.git", project.repository_url
  end

  test 'it should parse http Git url' do
    project = create('http://github.com/jlong/my-sass-ext.git')
    assert_equal "jlong", project.username
    assert_equal "my-sass-ext", project.reponame
    assert_equal "git@github.com:jlong/my-sass-ext.git", project.repository_url
  end

  test 'it should parse https Git url' do
    project = create('https://github.com/jlong/my-sass-ext.git')
    assert_equal "jlong", project.username
    assert_equal "my-sass-ext", project.reponame
    assert_equal "git@github.com:jlong/my-sass-ext.git", project.repository_url
  end

  def create(*args)
    GitHubProject.new(*args)
  end

end
