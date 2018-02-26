# frozen_string_literal: true

require_relative 'serialization/directory'
require_relative 'serialization/regenerate'

namespace :serialization do
  desc 'Regenerate serialized tries'
  task regenerate: %i(serialization:directory) do
    Serialization::Regenerate.new(
      dictionaries: %w(espanol words_with_friends),
      formats: %w(marshal marshal.zip),
    ).execute
  end

  desc 'Create serialization directories'
  task :directory do
    Serialization::Directory.create
  end
end
