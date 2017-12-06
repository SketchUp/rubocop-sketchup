module Examples

  def self.first_argument
    model = Sketchup.active_model

    model.start_operation('Short Operation', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('not capitalized.', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('programmer_name', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('Way too long description for menu item', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation("Way too long description for menu item", true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation(%[Way too long description for menu item], true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('Name_With_Underscore', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('Name.With.Period', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation("Name\tWith\tTabs", true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('Multiple  Spaces', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation

    model.start_operation('  Trim Spaces  ', true)
    model.active_entities.add_face([0,0,0], [9,0,0], [9,9,0], [0,9,0])
    model.commit_operation
  end

end
