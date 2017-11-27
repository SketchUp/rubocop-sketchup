# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::LoadPath do

  subject(:cop) { described_class.new }

  it 'registers an offense when setting $LOAD_PATH' do
    inspect_source('$LOAD_PATH = ["dummy"]')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for reading $LOAD_PATH' do
    inspect_source('dummy = $LOAD_PATH')
    expect(cop.offenses).to be_empty
  end

  described_class::MUTATORS.each do |var|
    it "registers an offense when modifying $LOAD_PATH with #{var.inspect}" do
      inspect_source("$LOAD_PATH.#{var}('dummy')")
      expect(cop.offenses.size).to eq(1)
    end
  end

  it 'registers an offense when modifying $LOAD_PATH with <<' do
    inspect_source('$LOAD_PATH << "dummy"')
    expect(cop.offenses.size).to eq(1)
  end

  %i(
    &
    *
    +
    -
    <=>
    ==
    []
    any?
    assoc
    at
    bsearch
    collect
    combination
    compact
    count
    cycle
    each
    each_index
    empty?
    eql?
    fetch
    find_index
    first
    flatten
    frozen?
    hash
    include?
    index
    initialize_copy
    inspect
    join
    last
    length
    map
    pack
    permutation
    product
    rassoc
    reject
    repeated_combination
    repeated_permutation
    reverse
    reverse_each
    rindex
    rotate
    sample
    select
    shuffle
    size
    slice
    sort
    take
    take_while
    to_a
    to_ary
    to_h
    to_s
    transpose
    uniq
    values_at
    zip
    |
  ).each do |var|
    it "does not register an offense when not modifying $LOAD_PATH with #{var.inspect}" do
      inspect_source("$LOAD_PATH.#{var}('dummy')")
      expect(cop.offenses).to be_empty
    end
  end

end
