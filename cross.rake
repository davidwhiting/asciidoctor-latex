require 'opal'

minify   = ENV['MINIFY'] == '1'
compress = ENV['COMPRESS'] == '1'

task :default => :dist

desc 'Build opal.js, asciidoctor-latex.js and endorsed extensions to build/'
task :dist do
  Opal::Processor.method_missing_enabled = false
  Opal::Processor.const_missing_enabled = false
  Opal::Processor.source_map_enabled = false
  Opal::Processor.dynamic_require_severity = :ignore

  Dir.mkdir 'build' unless File.directory? 'build'

  env = Opal::Environment.new
  env.js_compressor = Sprockets::ClosureCompressor if minify
  #env['opal'].write_to "build/opal.js#{compress ? '.gz' : nil}"

  # Use use_gem if you want to build against a release
  env.use_gem 'asciidoctor'
  env.use_gem 'htmlentities'
  # If the Gemfile points to a git repo or local directory, be sure to use `bundle exec rake ...`
  # Use append_path if you want to build against a local clone
  env.append_path 'lib' # 'asciidoctor/lib'

  #env['asciidoctor'].write_to "build/asciidoctor.js#{compress ? '.gz' : nil}"
  asciidoctor_latex = env['asciidoctor-latex']
  # NOTE hack to make version compliant with semver
  #asciidoctor_latex.instance_variable_set :@source, (asciidoctor_latex.instance_variable_get :@source)
  #    .sub(/'VERSION', "(\d+\.\d+.\d+)\.(.*)"/, '\'VERSION\', "\1-\2"')
  asciidoctor_latex.write_to "build/asciidoctor-latex.js#{compress ? '.gz' : nil}"
end
