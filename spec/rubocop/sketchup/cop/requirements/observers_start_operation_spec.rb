# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::SketchupRequirements::ObserversStartOperation do

  subject(:cop) { described_class.new }

  it 'does not register an offense for not starting an operation' do
    inspect_source(<<-'RUBY'.strip_indent)
      module Example
        class ExampleObserver < Sketchup::EntitiesObserver
          def onElementAdded(entities, entity)
            puts "onElementAdded: #{entity}"
          end
        end
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for starting a non-observer operation' do
    inspect_source(<<-RUBY.strip_indent)
      module Example
        def self.redify(entity)
          model = Sketchup.active_model
          model.start_operation("Red", true)
          entity.material = "red"
          model.commit_operation
        end
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for not starting a transparent operation' do
    inspect_source(<<-RUBY.strip_indent)
      module Example
        class ExampleObserver < Sketchup::EntitiesObserver
          def onElementAdded(entities, entity)
            model = Sketchup.active_model
            model.start_operation("Red", true, false, true)
            entity.material = "red"
            model.commit_operation
          end
        end
      end
    RUBY
    expect(cop.offenses).to be_empty
  end

  it 'registers an offense for starting a non-transparent operation' do
    inspect_source(<<-RUBY.strip_indent)
      module Example
        class ExampleObserver < Sketchup::EntitiesObserver
          def onElementAdded(entities, entity)
            model = Sketchup.active_model
            model.start_operation("Red", true)
            entity.material = "red"
            model.commit_operation
          end
        end
      end
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for explicitly starting a non-transparent operation' do
    inspect_source(<<-RUBY.strip_indent)
      module Example
        class ExampleObserver < Sketchup::EntitiesObserver
          def onElementAdded(entities, entity)
            model = Sketchup.active_model
            model.start_operation("Red", true, false, false)
            entity.material = "red"
            model.commit_operation
          end
        end
      end
    RUBY
    expect(cop.offenses.size).to eq(1)
  end

end
