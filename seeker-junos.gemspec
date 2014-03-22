Gem::Specification.new do |s|
  s.name              = 'seeker-junos'
  s.version           = '0.0.5'
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

  s.add_dependency 'net-ssh'
  s.add_dependency 'net-netrc'
  s.add_dependency 'slop'
end
