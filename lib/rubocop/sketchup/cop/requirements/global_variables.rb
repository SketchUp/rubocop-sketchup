# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Extensions in SketchUp all share the same Ruby environment on the user's
      # machine. Because of this it's important that each extension isolate
      # itself to avoid clashing with other extensions.
      #
      # Extensions submitted to Extension Warehouse is expected to not define
      # global variables.
      #
      # This cops looks for uses of global variables.
      # It does not report offenses for built-in global variables.
      # Built-in global variables are allowed by default. Additionally
      # users can allow additional variables via the AllowedVariables option.
      #
      # Note that backreferences like `$1`, `$2`, etc are not global variables.
      class GlobalVariables < SketchUp::Cop

        include SketchUp::NoCommentDisable
        include SketchUp::DynamicComponentGlobals

        MSG = 'Do not introduce global variables.'.freeze

        # predefined global variables their English aliases
        # http://www.zenspider.com/Languages/Ruby/QuickRef.html
        BUILT_IN_VARS = %i[
          $: $LOAD_PATH
          $" $LOADED_FEATURES
          $0 $PROGRAM_NAME
          $! $ERROR_INFO
          $@ $ERROR_POSITION
          $; $FS $FIELD_SEPARATOR
          $, $OFS $OUTPUT_FIELD_SEPARATOR
          $/ $RS $INPUT_RECORD_SEPARATOR
          $\\ $ORS $OUTPUT_RECORD_SEPARATOR
          $. $NR $INPUT_LINE_NUMBER
          $_ $LAST_READ_LINE
          $> $DEFAULT_OUTPUT
          $< $DEFAULT_INPUT
          $$ $PID $PROCESS_ID
          $? $CHILD_STATUS
          $~ $LAST_MATCH_INFO
          $= $IGNORECASE
          $* $ARGV
          $& $MATCH
          $` $PREMATCH
          $' $POSTMATCH
          $+ $LAST_PAREN_MATCH
          $stdin $stdout $stderr
          $DEBUG $FILENAME $VERBOSE $SAFE
          $-0 $-a $-d $-F $-i $-I $-l $-p $-v $-w
          $CLASSPATH $JRUBY_VERSION $JRUBY_REVISION $ENV_JAVA
        ].freeze

        SKETCHUP_VARS = %i[
          $loaded_files
        ].freeze

        # Some globals, like DC's, are being read from so often that it's better
        # to ignore these to reduce noise.
        READ_ONLY_VARS = DC_GLOBALS

        ALLOWED_VARS = BUILT_IN_VARS | SKETCHUP_VARS


        def allowed_var?(global_var)
          ALLOWED_VARS.include?(global_var)
        end

        def read_allowed?(global_var)
          READ_ONLY_VARS.include?(global_var)
        end

        def on_gvar(node)
          global_var, = *node
          check(node) unless read_allowed?(global_var)
        end

        def on_gvasgn(node)
          check(node)
        end

        def check(node)
          global_var, = *node

          return if allowed_var?(global_var)

          add_offense(node, location: :name, severity: :error)
        end
      end
    end
  end
end
