# frozen_string_literal: true

require 'fileutils'
require_relative '../helpers/path'

module Serialization
  class Directory
    include Helpers::Path

    def self.create
      new.create
    end

    def create
      FileUtils.mkdir_p tries_path
    end
  end
end
