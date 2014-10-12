require 'claudius'
require 'test/unit'

class Test_local_execution < Test::Unit::TestCase

  def teardown
    `rm -rf Hello123456`
  end

  def test_simple
    helloExp = experiment 'Hello' do
      execute do
        ssh 'mkdir Hello123456'
      end
    end
    helloExp.run()
    result = `ls -la`
    assert_equal(true, result.include?('Hello123456'), 'Test should create a folder in current directory')
  end

end