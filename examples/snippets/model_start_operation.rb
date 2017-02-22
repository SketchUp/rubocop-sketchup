module Examples

  def self.first_argument
    model = Sketchup.active_model

    model.start_operation('Short Operation', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('not capitalized.', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('programmer_name', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('Way too long description for menu item', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation
  end

  def self.second_argument
    model = Sketchup.active_model

    model.start_operation('Next Transparent')
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('Next Transparent', false)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('Next Transparent', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation
  end

  def self.third_argument
    model = Sketchup.active_model
    model.start_operation('Next Transparent', true, true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation
  end

  class ExampleObserver
    def onElementAdded(entities, entity)
      return if entity.deleted?
      entity.model.start_operation('Colorize', true, false, true)
      entity.material = 'red'
      entity.model.commit_operation
    end

    # TODO: Should flag not using .start_operation.
    # TODO: Should flag not checking .deleted? or .valid?
    def onElementModified(entities, entity)
      entity.material = 'red'
    end
  end

end
