Gem::Specification.new do |spec|
  spec.name          = 'emcien_finch'
  spec.version       = '0.0.1'
  spec.date          = Time.now.utc.strftime("%Y-%m-%d")
  spec.description   = 'A lightweight wrapper for the Twitter API 1.1'
  spec.summary       = spec.description
  spec.authors       = ['James Dabbs']
  spec.email         = 'jdabbs@emcien.com'
  spec.files         = %w(README.md emcien_finch.gemspec)
  spec.files        += Dir.glob('lib/**/*.rb')
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.8'
  spec.add_dependency 'excon', '~> 0.20'
  spec.add_dependency 'simple_oauth', '~> 0.1'
  spec.add_dependency 'oj', '~> 1.4'
  spec.add_dependency 'rack'
end