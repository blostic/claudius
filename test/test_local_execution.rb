require 'cloudmate'
require 'test/unit'

class Test_local_execution < Test::Unit::TestCase

  def teardown
    `rm -rf Hello123456`
  end

  def test_simple
    experiment 'Hello' do
      execute do
        ssh 'mkdir Hello123456'
      end
    end
    result = `ls -la`
    assert_equal(true, result.include?('Hello123456'), 'Test should create a folder in current directory')
  end

end