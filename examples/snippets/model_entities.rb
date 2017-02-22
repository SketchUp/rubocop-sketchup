module Examples

  def self.find_faces
    model = Sketchup.active_model
    faces = model.entities.select { |entity| entity.is_a?(Sketchup::Face) }
  end

end
