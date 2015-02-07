Gem::Specification.new do |s|
  s.name              = 'seeker-junos'
  s.version           = '0.1.0'
  s.licenses          = %w( Apache-2.0 )
  s.platform          = Gem::Platform::RUBY
  s.authors           = [ 'Saku Ytti' ]
  s.email             = %w( saku@ytti.fi )
  s.homepage          = 'http://github.com/ytti/seeker-junos'
  s.summary           = 'find hidden commands in junos'
  s.description       = 'logs via ssh to junos devices and brute forces hidden passwords out'
  s.rubyforge_project = s.name
  s.files             = `git ls-files`.split("\n")
  s.executables       = %w( seeker-junos )
  s.require_path      = 'lib'

  s.add_runtime_dependency 'net-ssh',   '~> 2.9'
  s.add_runtime_dependency 'net-netrc', '~> 0.2'
  s.add_runtime_dependency 'slop',      '~> 3.6'
end
