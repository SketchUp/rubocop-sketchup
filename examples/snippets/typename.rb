module Examples

  def self.find_faces
    model = Sketchup.active_model
    faces = model.active_entities.select { |entity| entity.typename == 'Face' }
  end

  # TODO(thomthom): detect use of model.selection and .add/.remove/.toggle
  # inside of loops. Recommend bulk actions.

end
