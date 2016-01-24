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
    before(:each) do
      FileUtils.mkdir('tmp') unless Dir.exist?('tmp')
    end

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
        @cache = {
          :DE258071574=>
            {:country_code=>"DE",
             :vat_number=>"258071574",
             :request_date=> Date.today.to_s,
             :valid=>false,
             :name=>"---",
             :address=>"---",
             :@xmlns=>"urn:ec.europa.eu:taxud:vies:services:checkVat:types"},
           :DE258071573=>
            {:country_code=>"DE",
             :vat_number=>"258071573",
             :request_date=> Date.today.to_s,
             :valid=>true,
             :name=>"---",
             :address=>"---",
             :@xmlns=>"urn:ec.europa.eu:taxud:vies:services:checkVat:types"},
           :DE258071575=>
            {:country_code=>"DE",
             :vat_number=>"258071575",
             :request_date=> Date.today.to_s,
             :valid=>false,
             :name=>"---",
             :address=>"---",
             :@xmlns=>"urn:ec.europa.eu:taxud:vies:services:checkVat:types"}
        }
      end

      context 'with non expired entries' do
        before do
          File.open('spec/fixtures/cache.json', 'w') { |f| f.write(@cache.to_json) }
          Valvat::Lookup.cache_path = 'spec/fixtures/cache.json'
        end

        it 'should load the cache' do
          expect(Valvat::Lookup.cache.any?).to be true
          expect(Valvat::Lookup.cache[:DE258071574][:valid]).to be false
          expect(Valvat::Lookup.validate('DE258071574')).to be false
        end
      end

      context 'with expired entries' do
        before do
          @cache[:DE258071574][:request_date] = '2016-01-14'
          File.open('spec/fixtures/cache.json', 'w') { |f| f.write(@cache.to_json) }
          Valvat::Lookup.cache_path = 'spec/fixtures/cache.json'
        end

        it 'should delete old entries' do
          expect(Valvat::Lookup.cache[:DE258071574]).to be_nil
        end
      end
    end
  end

  describe '.expiration_days' do
    it 'should have a default value' do
      expect(Valvat::Lookup.expiration_days).to eq 7
    end

    it 'should be customized' do
      Valvat::Lookup.expiration_days = 365
      expect(Valvat::Lookup.expiration_days).to eq 365
    end
  end
end
