# frozen_string_literal: true

require 'spec_helper'
require 'zip'

describe Rambling::Trie do
  let(:assets_path) { File.join SPEC_ROOT, 'assets' }

  describe '::VERSION' do
    let(:root_path) { File.join SPEC_ROOT, '..' }
    let(:readme_path) { File.join root_path, 'README.md' }
    let(:readme) { File.read readme_path }
    let(:changelog_path) { File.join root_path, 'CHANGELOG.md' }
    let(:changelog) { File.read changelog_path }

    let(:changelog_versions) do
      matches = []
      changelog.scan %r{^## (\d+\.\d+\.\d+)} do |match|
        matches << match[0]
      end
      matches
    end

    it 'matches with the version in the README badge' do
      match = %r{\?version=(?<version>.*)$}.match readme
      expect(match['version']).to eq Rambling::Trie::VERSION
    end

    it 'is the version before the one at the top of the CHANGELOG' do
      top_changelog_version = Gem::Version.new changelog_versions.first
      minor_version = Rambling::Trie::VERSION.split('.')[..1].join('.') # 1.2.3 => 1.2
      next_versions = ["#{Rambling::Trie::VERSION}.0", Rambling::Trie::VERSION, minor_version]
      expect(next_versions.map { |v| Gem::Version.new(v).bump }).to include top_changelog_version
    end

    it 'is included in the CHANGELOG diffs' do
      changelog_versions.shift
      expect(changelog_versions.first).to eq Rambling::Trie::VERSION
    end
  end

  context 'when providing words directly' do
    it_behaves_like 'a compressible trie' do
      let(:trie) { described_class.create }
      let(:words) { %w(a couple of words for our full trie integration test) }

      before { trie.concat words }
    end
  end

  context 'when provided with words with unicode characters' do
    it_behaves_like 'a compressible trie' do
      let(:trie) { described_class.create }
      let :words do
        %w(poquísimas palabras para nuestra prueba de integración completa 🙃)
      end

      before { trie.concat words }
    end
  end

  context 'when provided with a filepath' do
    let(:trie) { described_class.create filepath }
    let(:words) { File.readlines(filepath).map(&:chomp) }

    context 'with english words' do
      it_behaves_like 'a compressible trie' do
        let(:filepath) { File.join assets_path, 'test_words.en_US.txt' }
      end
    end

    context 'with unicode characters' do
      it_behaves_like 'a compressible trie' do
        let(:filepath) { File.join assets_path, 'test_words.es_DO.txt' }
      end
    end
  end

  describe 'dump and load' do
    let(:words_filepath) { File.join assets_path, 'test_words.en_US.txt' }
    let(:words) { File.readlines(words_filepath).map(&:chomp) }

    context 'when serialized with Ruby marshal format (default)' do
      it_behaves_like 'a serializable trie' do
        let(:trie_to_serialize) { described_class.create words_filepath }
        let(:file_format) { :marshal }
      end
    end

    context 'when serialized with YAML' do
      it_behaves_like 'a serializable trie' do
        let(:trie_to_serialize) { described_class.create words_filepath }
        let(:file_format) { :yml }
      end
    end

    context 'when serialized with zipped Ruby marshal format' do
      let!(:original_on_exists_proc) { Zip.on_exists_proc }
      let!(:original_continue_on_exists_proc) { Zip.continue_on_exists_proc }

      before do
        Zip.on_exists_proc = true
        Zip.continue_on_exists_proc = true
      end

      after do
        Zip.on_exists_proc = original_on_exists_proc
        Zip.continue_on_exists_proc = original_continue_on_exists_proc
      end

      it_behaves_like 'a serializable trie' do
        let(:trie_to_serialize) { described_class.create words_filepath }
        let(:file_format) { 'marshal.zip' }
      end
    end
  end
end
