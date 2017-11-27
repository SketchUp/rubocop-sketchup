module Examples

  extension = nil
  some_var = nil

  Sketchup.register_extension(extension, true)

  Sketchup.register_extension(extension, false)

  Sketchup.register_extension(extension)

  Sketchup.register_extension(extension, some_var)

end
