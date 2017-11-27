module Example
  filename = 'hello/main.rb'
  extension = SketchupExtension.new("Extension Name", filename)
  Sketchup.register_extension(extension, true)
end
