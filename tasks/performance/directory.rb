# frozen_string_literal: true

require 'fileutils'

module Performance
  class Directory
    include Helpers::Path

    def self.create
      new.create
    end

    def create
      FileUtils.mkdir_p reports_path
    end

    def reports_path
      path 'reports', Rambling::Trie::VERSION
    end
  end
end
