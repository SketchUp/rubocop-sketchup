# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::LoadPath, :config do

  it 'registers an offense when setting $LOAD_PATH' do
    expect_offense(<<~RUBY)
      $LOAD_PATH = ["dummy"]
      ^^^^^^^^^^^^^^^^^^^^^^ Do not modify the load path.
    RUBY
  end

  it 'does not register an offense for reading $LOAD_PATH' do
    expect_no_offenses(<<~RUBY)
      dummy = $LOAD_PATH
    RUBY
  end

  described_class::MUTATORS.each do |var|
    it "registers an offense when modifying $LOAD_PATH with #{var.inspect}" do
      arr = '^' * var.to_s.length
      expect_offense(<<~RUBY)
        $LOAD_PATH.#{var}('dummy')
        ^^^^^^^^^^^#{arr}^^^^^^^^^ Do not modify the load path.
      RUBY
    end
  end

  it 'registers an offense when modifying $LOAD_PATH with <<' do
    expect_offense(<<~RUBY)
      $LOAD_PATH << "dummy"
      ^^^^^^^^^^^^^^^^^^^^^ Do not modify the load path.
    RUBY
  end

  %i[
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
  ].each do |var|
    it "does not register an offense when not modifying $LOAD_PATH with #{var.inspect}" do
      expect_no_offenses(<<~RUBY)
        $LOAD_PATH.#{var}('dummy')
      RUBY
    end
  end

end
