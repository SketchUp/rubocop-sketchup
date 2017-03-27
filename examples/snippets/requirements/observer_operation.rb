module Examples

  class ExampleObserver
    def onElementAdded(entities, entity)
      return if entity.deleted?
      entity.model.start_operation('Colorize', true, false, true)
      entity.material = 'red'
      entity.model.commit_operation
    end

    # TODO: Should flag not using .start_operation.
    # TODO: Should flag not checking .deleted? or .valid?
    def onElementModified(entities, entity)
      entity.material = 'red'
    end
  end

end
