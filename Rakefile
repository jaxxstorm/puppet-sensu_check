require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

exclude_paths = %w(
  pkg/**/*
  vendor/**/*
  spec/**/*
)

PuppetLint.configuration.ignore_paths = exclude_paths
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
PuppetSyntax.exclude_paths = exclude_paths

desc "Run syntax, lint and spec tests."
task :test => [
  :syntax,
  :spec,
  :lint,
]
