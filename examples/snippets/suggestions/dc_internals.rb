module Examples

  def self.dc_monkey_patched_method
    tr = Geom::Transformation.scaling(5)
    x = tr.xscale
  end

  def self.valid_api_method
    tr = Geom::Transformation.scaling(5)
    matrix = tr.to_a
  end


  def self.dc_monkey_patched_method_with_variable_filter
    entities = Sketchup.active_model.entities
    instance = entities.grep(Sketchup::ComponentInstance)
    description = instance.description
  end

  def self.valid_api_method_with_variable_filter
    entities = Sketchup.active_model.definitions
    definition = definitions.first
    description = definition.description
  end

end
