Gem::Specification.new do |spec|
  spec.name          = 'finch'
  spec.version       = '0.0.0'
  spec.date          = '2012-11-13'
  spec.description   = 'A lightweight wrapper for the Twitter API 1.1'
  spec.summary       = spec.description
  spec.authors       = ['James Dabbs']
  spec.email         = 'jdabbs@emcien.com'
  spec.files         = %w(README.md finch.gemspec)
  spec.files        += Dir.glob('lib/**/*.rb')
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.8'
  spec.add_dependency 'simple_oauth', '~> 0.1'
  spec.add_dependency 'oj', '~> 1.4'
  spec.add_dependency 'rack'
end