module Examples

  def self.find_faces
    model = Sketchup.active_model
    faces = model.active_entities.select { |entity| entity.typename == 'Face' }
  end

end
