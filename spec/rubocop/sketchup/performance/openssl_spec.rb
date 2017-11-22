# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupPerformance::OpenSSL do

  subject(:cop) { described_class.new }

  it 'registers an offense for use of OpenSSL' do
    inspect_source('require "openssl"')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of SecureRandom' do
    inspect_source('require "securerandom"')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of Net::HTTPS' do
    inspect_source('require "net/https"')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for use of Net::HTTP' do
    inspect_source('require "net/http"')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for other modules' do
    inspect_source('require "json"')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for non-string literals' do
    inspect_source('require filename')
    expect(cop.offenses).to be_empty
  end

end
