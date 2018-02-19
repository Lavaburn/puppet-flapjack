# Required gems
require 'rubygems'
require 'bundler/setup'
require 'hiera'

# Gems: Rake tasks
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

# These gems aren't always present
begin
	#On Travis with --without development
	require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end


# Directories that don't need to be checked (Lint/Syntax)
exclude_paths = [
  "pkg/**/*",
	"spec/**/*",
  "examples/**/*",
]


# Settings for syntax checker
PuppetSyntax.exclude_paths = exclude_paths


PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
  
  config.disable_checks = [
    "80chars", "140chars", 
    "variable_is_lowercase", "class_inherits_from_params_class",
    "relative_classname_inclusion", "trailing_comma",
    "variable_contains_upcase", "version_comparison",
    "variable_is_lowercase", "arrow_on_right_operand_line"
  ]

  config.with_context = true
  config.relative = true
  #  config.log_format = '%{filename} - %{message}'
  #  config.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
end

# Extra Tasks
desc "Run metadata, syntax, lint, and spec tests."
task :test => [
  #:metadata,     # TODO Travis BUGFIX: "Don't know how to build task 'metadata' (see --tasks)"
	:syntax,
	:lint,
	:spec,
]
