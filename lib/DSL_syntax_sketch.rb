benchmark 'test'
  providers
    provider 'localhost'
    provider 'aws'
      credentials
        id 'dsdf'
        key 'dfgd'
      instances
        [m1, m2, m3]
    provider 'cloud9'
      credentials
        id 'dsf'
        keyfile 'sfgd'
  experiments
    experiment 'Montage'
      configuration
        packages
          package 'ruby'
            version '2.0'
            repository 'fsdfs'
            # check 'ruby --version' equal '2.0'
          package 'node'
            version '0.2.1'
        initScripts
          script './foo.ssh'
        files
          file 'f1'
            source '../exp'
            destination '/home/foo/exp'
      params
        param 'paramName'
          value v1
          value v2
          value v3
      metrics
        metric time
        metric io
        metric personal './script.sh'
      execution
        beforeEach 'set JAVA_HOME="asd"'
        command '#{f1.destination} #{paramName}'
        afterEach execute "./script"