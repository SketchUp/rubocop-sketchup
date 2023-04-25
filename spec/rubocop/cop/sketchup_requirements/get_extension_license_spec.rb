# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::GetExtensionLicense, :config do

  context 'string literal extension GUID' do

    it 'registers an offense when extension GUID contains trailing spaces' do
      expect_offense(<<~RUBY)
        Sketchup::Licensing.get_extension_license("4e215280-dd23-40c4-babb-b8a8dd29d5ee  ")
                                                                                       ^^ Extra space in extension GUID
      RUBY
    end

    it 'registers an offense when extension GUID is too short' do
      expect_offense(<<~RUBY)
        Sketchup::Licensing.get_extension_license("4e215280-dd23-40c4-babb-b8a8dd29d5e")
                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Invalid extension GUID
      RUBY
    end

    it 'registers an offense when extension GUID is too long' do
      expect_offense(<<~RUBY)
        Sketchup::Licensing.get_extension_license("4e215280-dd23-40c4-babb-b8a8dd29d5eex")
                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Invalid extension GUID
      RUBY
    end

    it 'registers an offense when extension GUID is not valid' do
      expect_offense(<<~RUBY)
        Sketchup::Licensing.get_extension_license("abcdefghijklmnopqrstuvwzyx0123456789")
                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Invalid extension GUID
      RUBY
    end

    it 'does not register an offense when extension GUID is valid' do
      expect_no_offenses(<<~RUBY)
        Sketchup::Licensing.get_extension_license("4e215280-dd23-40c4-babb-b8a8dd29d5ee")
      RUBY
    end

  end

  context 'string literal variable extension GUID' do

    it 'does not register an offense when string literal extension GUID is valid' do
      expect_no_offenses(<<~RUBY)
        ext_id = "4e215280-dd23-40c4-babb-b8a8dd29d5ee"
        ext_lic = Sketchup::Licensing.get_extension_license(ext_id)
        if ext_lic.licensed?
          puts "Extension is licensed."
        end
      RUBY
    end

  end

  context 'unsafe storage of extension GUID' do

    it 'registers an offense when extension GUID is not a local string literal' do
      expect_offense(<<~RUBY)
        module Example
          def check(extension_id)
            license = Sketchup::Licensing.get_extension_license(extension_id)
                                                                ^^^^^^^^^^^^ Only pass in extension GUID from local string literals.
          end
        end
      RUBY
    end

    it 'registers an offense when extension GUID is stored as a constant' do
      expect_offense(<<~RUBY)
        EXTENSION_ID = "4e215280-dd23-40c4-babb-b8a8dd29d5ee"
        license = Sketchup::Licensing.get_extension_license(EXTENSION_ID)
                                                            ^^^^^^^^^^^^ Only pass in extension GUID from local string literals.
      RUBY
    end

    it 'registers an offense when extension GUID is stored as a constant (unknown source)' do
      expect_offense(<<~RUBY)
        license = Sketchup::Licensing.get_extension_license(EXTENSION_ID)
                                                            ^^^^^^^^^^^^ Only pass in extension GUID from local string literals.
      RUBY
    end

    it 'registers an offense when extension GUID is stored as an instance variable' do
      expect_offense(<<~RUBY)
        @extension_id = "4e215280-dd23-40c4-babb-b8a8dd29d5ee"
        license = Sketchup::Licensing.get_extension_license(@extension_id)
                                                            ^^^^^^^^^^^^^ Only pass in extension GUID from local string literals.
      RUBY
    end

    it 'registers an offense when extension GUID is stored as an instance variable (unknown source)' do
      expect_offense(<<~RUBY)
        license = Sketchup::Licensing.get_extension_license(@extension_id)
                                                            ^^^^^^^^^^^^^ Only pass in extension GUID from local string literals.
      RUBY
    end

    it 'registers an offense when extension GUID is stored as a class variable' do
      expect_offense(<<~RUBY)
        @@extension_id = "4e215280-dd23-40c4-babb-b8a8dd29d5ee"
        license = Sketchup::Licensing.get_extension_license(@@extension_id)
                                                            ^^^^^^^^^^^^^^ Only pass in extension GUID from local string literals.
      RUBY
    end

    it 'registers an offense when extension GUID is stored as a class variable (unknown source)' do
      expect_offense(<<~RUBY)
        license = Sketchup::Licensing.get_extension_license(@@extension_id)
                                                            ^^^^^^^^^^^^^^ Only pass in extension GUID from local string literals.
      RUBY
    end

    it 'registers an offense when extension GUID is stored as a global variable' do
      expect_offense(<<~RUBY)
        $extension_id = "4e215280-dd23-40c4-babb-b8a8dd29d5ee"
        license = Sketchup::Licensing.get_extension_license($extension_id)
                                                            ^^^^^^^^^^^^^ Only pass in extension GUID from local string literals.
      RUBY
    end

    it 'registers an offense when extension GUID is stored as a global variable (unknown source)' do
      expect_offense(<<~RUBY)
        license = Sketchup::Licensing.get_extension_license($extension_id)
                                                            ^^^^^^^^^^^^^ Only pass in extension GUID from local string literals.
      RUBY
    end

  end

end
