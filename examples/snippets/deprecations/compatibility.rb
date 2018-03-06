module Examples

  def self.incompatible_class_2017
    dialog = UI::HtmlDialog.new
    dialog.show
  end

  def self.incompatible_class_2018
    image = Sketchup::ImageRep.new
  end


  def self.incompatible_module_2017
    request = Sketchup::Http::Request.new
  end

  def self.incompatible_module_2018
    group = Layout::Group.new(entity_array)
  end


  def self.incompatible_constant_2018
    flags = Geom::PolygonMesh::MESH_POINTS | Geom::PolygonMesh::MESH_NORMALS
  end


  def self.incompatible_module_method_2018
    Sketchup.send_to_layout("hexaflexagon.layout")
  end

end
