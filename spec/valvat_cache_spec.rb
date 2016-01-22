require 'spec_helper'

describe ValvatCache do
  it 'has a version number' do
    expect(ValvatCache::VERSION).not_to be nil
  end

  after(:each) do
    Valvat::Lookup.cache_path = nil
    Valvat::Lookup.cache = nil
  end

  describe '.cache_path' do
    after(:each) do
      FileUtils.rm('tmp/cache.json')
    end

    it 'generates a cache file' do
      Valvat::Lookup.cache_path = 'tmp/cache.json'

      expect(File.file?('tmp/cache.json')).to be true
    end
  end

  describe '.cache' do
    context 'given an already created cache' do

      before(:each) do
        Valvat::Lookup.cache_path = 'spec/fixtures/cache.json'
      end

      it 'should load the cache' do
        expect(Valvat::Lookup.cache.any?).to be true
        expect(Valvat::Lookup.cache[:DE258071574][:valid]).to be false
        expect(Valvat::Lookup.validate('DE258071574')).to be false
      end
    end
  end
end
