# Installation

## Requirements

* Standalone Ruby 2.2+ installation on the system. This is not intended to be used inside of SketchUp. Mac users should have Ruby already on the system, but might find it beneficial to use [RVM](https://rvm.io/). Windows users need to install Ruby from https://rubyinstaller.org/.

* The [RuboCop](http://batsov.com/rubocop/) gem must also be installed. RuboCop's development is moving at a very rapid pace and there are often backward-incompatible changes between minor releases (since they haven't reached version 1.0 yet). Because of this it's recommended to be explicit about the RuboCop version you install:

        gem install rubocop -v 0.69.0

## Install

Install the `rubocop-sketchup` gem:

    gem install rubocop-sketchup

## Bundler

If you use [bundler](http://bundler.io/) to manage you're project's dependencies put this in your Gemfile:

    gem 'rubocop', '~> 0.69.0'
    gem 'rubocop-sketchup', '~> 0.10.0'
