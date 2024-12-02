# frozen_string_literal: true

LIB_REGEX = %r{^lib/(.+)\.rb$}

guard :reek, all_on_start: true, run_all: true do
  watch(LIB_REGEX)
end

guard :rspec, cmd: 'rspec', all_on_start: true, all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(LIB_REGEX) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }
end

guard :rubocop, all_on_start: true do
  watch(LIB_REGEX)
end

guard :yard, server: false do
  watch(LIB_REGEX)
end
