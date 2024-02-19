# frozen_string_literal: true

require 'spec_helper'

describe Rambling::Trie::Configuration::ProviderCollection do
  let(:configured_default) { nil }
  let :configured_providers do
    { one: first_provider, two: second_provider }
  end

  let :first_provider do
    instance_double Rambling::Trie::Serializers::Marshal, :first_provider
  end
  let :second_provider do
    instance_double Rambling::Trie::Serializers::Marshal, :second_provider
  end

  let :provider_collection do
    described_class.new(
      :provider,
      configured_providers,
      configured_default,
    )
  end

  describe '.new' do
    it 'has a name' do
      expect(provider_collection.name).to eq :provider
    end

    it 'has the given providers' do
      expect(provider_collection.providers)
        .to eq one: first_provider, two: second_provider
    end

    it 'has a default provider' do
      expect(provider_collection.default).to eq first_provider
    end

    context 'when a default is provided' do
      let(:configured_default) { second_provider }

      it 'has that as the default provider' do
        expect(provider_collection.default).to eq second_provider
      end
    end
  end

  describe 'aliases and delegates' do
    let(:providers) { provider_collection.providers }

    before do
      allow(providers).to receive_messages(
        :[] => 'value',
        keys: %i(a b),
      )
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'delegates `#[]` to providers' do
      expect(provider_collection[:key]).to eq 'value'
      expect(providers).to have_received(:[]).with :key
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations
    it 'aliases `#formats` to `providers#keys`' do
      expect(provider_collection.formats).to eq %i(a b)
      expect(providers).to have_received :keys
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe '#add' do
    let :provider do
      instance_double Rambling::Trie::Serializers::Marshal, :provider
    end

    before do
      provider_collection.add :three, provider
    end

    it 'adds a new provider' do
      expect(provider_collection.providers[:three]).to eq provider
    end
  end

  describe '#default=' do
    let :other_provider do
      instance_double Rambling::Trie::Serializers::Marshal, :other_provider
    end

    context 'when the given value is in the providers list' do
      it 'changes the default provider' do
        provider_collection.default = second_provider
        expect(provider_collection.default).to eq second_provider
      end
    end

    context 'when the given value is not in the providers list' do
      it 'raises an error and keeps the default provider' do
        expect { provider_collection.default = other_provider }
          .to raise_error(ArgumentError)
          .and(not_change { provider_collection.default })
      end

      it 'raises an ArgumentError' do
        expect { provider_collection.default = other_provider }
          .to raise_error ArgumentError
      end
    end

    context 'when the providers list is empty' do
      let(:configured_providers) { {} }

      it 'accepts nil' do
        provider_collection.default = nil
        expect(provider_collection.default).to be_nil
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'raises an ArgumentError for any other provider' do
        expect do
          provider_collection.default = other_provider
        end.to raise_error ArgumentError
        expect(provider_collection.default).to be_nil
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  describe '#resolve' do
    context 'when the file extension is one of the providers' do
      [
        ['hola.one', :first_provider],
        ['hola.two', :second_provider],
      ].each do |test_params|
        filepath, provider = test_params

        it 'returns the corresponding provider' do
          provider_instance = public_send provider
          expect(provider_collection.resolve filepath).to eq provider_instance
        end
      end
    end

    context 'when the file extension is not one of the providers' do
      %w(hola.unknown hola).each do |filepath|
        it 'returns the default provider' do
          expect(provider_collection.resolve filepath).to eq first_provider
        end
      end
    end
  end

  describe '#reset' do
    let(:configured_default) { second_provider }
    let :provider do
      instance_double Rambling::Trie::Serializers::Marshal, :provider
    end

    before do
      provider_collection.add :three, provider
      provider_collection.default = provider
    end

    it 'resets to back to the initially configured values (:three => nil)' do
      provider_collection.reset
      expect(provider_collection[:three]).to be_nil
    end

    it 'resets to back to the initially configured default' do
      provider_collection.reset
      expect(provider_collection.default).to eq second_provider
    end
  end
end
