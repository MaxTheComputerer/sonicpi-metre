Gem::Specification.new do |s|
  s.name        = "sonicpi-metre"
  s.version     = "1.0.0"
  s.summary     = "Sonic Pi - Metre"
  s.description = "Implementation of metre and probabilistic micro-timing for Sonic Pi. Requires Sonic Pi. See GitHub page for more details."
  s.authors     = ["Max Johnson"]
  s.email       = "maxelliottjohnson@hotmail.co.uk"
  s.files       = ["lib/sonicpi/metre.rb",
      "lib/sonicpi/metre/metre.rb",
      "lib/sonicpi/metre/bar.rb",
      "lib/sonicpi/metre/distribution.rb",
      "lib/sonicpi/metre/style.rb",
      "lib/sonicpi/lang/sound.rb",
      "lib/sonicpi/lang/western_theory.rb"]
  s.homepage    =
    "https://rubygems.org/gems/sonicpi-metre"
  s.license     = "MIT"
  s.metadata    = { "source_code_uri" => "https://github.com/MaxTheComputerer/sonicpi-metre" }
end
