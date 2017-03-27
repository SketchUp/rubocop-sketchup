module Examples

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

end
