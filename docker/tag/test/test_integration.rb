# frozen_string_literal: true

require 'minitest/autorun'

class TestIntegration < Minitest::Test
  def test_runs_and_tags
    env = { 'DOCKER_CMD' => 'test/fixtures/fake_docker_version.sh' }
    out = exec(env, './tag.rb one two --no-env --no-latest').strip
    want = ['tagging one as two:1.0.0', 'tagging one as two:1'].join "\n"
    assert_equal out, want
  end

  # rubocop:disable MethodLength
  def test_runs_and_tags_with_env
    env = {
      'DOCKER_CMD' => 'test/fixtures/fake_docker_version.sh',
      'GITHUB_SHA' => '123456abcd',
      'GITHUB_REF' => 'master'
    }
    out = exec(env, './tag.rb one two --no-env').strip
    want = [
      'tagging one as two:1.0.0',
      'tagging one as two:1',
      'tagging one as two:master',
      'tagging one as two:123456a',
      'tagging one as two:latest'
    ].join "\n"
    assert_equal out, want
  end
  # rubocop:enable all

  def teardown
    %w[GITHUB_REF GITHUB_SHA DOCKER_CMD].each do |e|
      ENV.delete(e)
    end
  end
end
