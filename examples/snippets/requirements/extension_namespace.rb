module Examples

  # rubocop:disable SketchupRequirements/GlobalVariables
  def self.global_variables
    $global_var = 'naughty'
    value = $read_global
  end

  # rubocop:disable SketchupRequirements/GlobalVariables
  def self.known_global_variables
    mode = $VERBOSE
  end

  # TODO(thomthom): Separate cop
  def self.modify_loadpath
    $LOAD_PATH << './no/such/folder'
  end

end


module SecondNamespace
  # Rubocop should have picked up Examples from earlier and expect that to be
  # the extension namespace.
end


def global_method
  # Should not be accepted.
end

@global_instance_variables = 'naughty'

@@global_class_variables = 'naughty'


class String
  def custom_method
    # Should not be accepted.
  end
end


module Math
  def sin(*args)
    # Should not be allowed.
  end
end


module Sketchup
  module Naughty
  end

  class Face
    def typename
    end
  end
end
