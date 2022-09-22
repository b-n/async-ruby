#!/usr/bin/env ruby

require 'base64'
require 'json'
require 'bundler'
#require 'async'
#require 'async/barrier'
#require 'async/semaphore'

DEFAULT_APPS = %w[ab accounts assets auctioneer-tools augeo auth buyer catawiki catawiki-r4 cerberus customer-info customer-support datascience-api employee-identity feedback finance fulfilment images jobs landscape lots machine-translation mailer marketing message-center nginx orders payments sales search seller-center sherlock shipping translation-keys translations].sort
GEM_FILE = 'Gemfile.lock'
GEMS = %w[cw-sdk cw-api cw-metrics cw-ab-test catbus rails resque sidekiq]

APPS = DEFAULT_APPS;

def lockfile_parser(app, lockfile_name)
  content = JSON.parse(`gh api repos/catawiki/cw-#{app}/contents/#{lockfile_name}`)

  lock_file_contents = Base64.decode64(content['content'])
   
  Bundler::LockfileParser.new(lock_file_contents)
end

def gem_versions(lockfile, gems)
  # Parse the lockfile, extract the specified gems with their versions. If the
  # gem does not exist, we expect an empty string (printing `nil` isn't fun`).
  gems.map { |g|
    spec = lockfile.specs.detect { |s| s.name == g }
    next '' if spec.nil?

    if spec.source.class == Bundler::Source::Git
      next "git-#{spec.source.ref}"
      #next "git-#{spec.source.send(:shortref_for_display, spec.source.revision)}"
    end

    spec.version.version
  }
end

def print_table(rows)
  # expects [[],[],...]
  column_sizes = rows.reduce(
    Array.new(rows.first.size) { |i| 0 } 
  ) do |accumulator, row|
    columns = row.map(&:size)
    [accumulator, columns].transpose.map(&:max)
  end

  padding = 1

  format_string = column_sizes.reduce('') { |acc, size| acc + "%-#{size + padding}s " }

  rows.each { |row| puts format_string % row }
end

def run(apps, gems, lockfile_name: GEM_FILE)
  start = Time.now

  results = []
  apps.each do |app|
    lockfile = lockfile_parser(app, lockfile_name)
    results += [gem_versions(lockfile, gems).prepend(app)]
  end

  sorted_results = results.sort { |a, b| a[0] <=> b[0] } 

  sorted_results.prepend(gems.map(&:clone).prepend('app'))
  print_table sorted_results

  puts "Total Time: #{Time.now - start}"
end

run(APPS, GEMS)
