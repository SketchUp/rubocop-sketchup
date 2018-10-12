# frozen_string_literal: true

module RuboCop
  module Cop
    module SketchupRequirements
      # Extensions in SketchUp all share the same Ruby environment on the user's
      # machine. Because of this it's important that each extension isolate
      # itself to avoid clashing with other extensions.
      #
      # Extensions submitted to Extension Warehouse is expected to not modify
      # core Ruby functionality.
      class RubyCoreNamespace < SketchUp::Cop

        include SketchUp::NoCommentDisable
        include SketchUp::NamespaceChecker

        MSG = 'Do not modify Ruby core functionality.'.freeze

        # We check only against the top level namespaces. The core define more
        # objects, but they are under one of the top level namespaces listed.

        NAMESPACES_RUBY_186 = %w(
          ArgumentError
          Array
          Bignum
          Binding
          Class
          Comparable
          Continuation
          Data
          Dir
          EOFError
          Enumerable
          Errno
          Exception
          FalseClass
          File
          FileTest
          Fixnum
          Float
          FloatDomainError
          GC
          Hash
          IO
          IOError
          IndexError
          Integer
          Interrupt
          Kernel
          LoadError
          LocalJumpError
          Marshal
          MatchData
          Math
          Method
          Module
          NameError
          NilClass
          NoMemoryError
          NoMethodError
          NotImplementedError
          Numeric
          Object
          ObjectSpace
          Precision
          Proc
          Process
          Range
          RangeError
          Regexp
          RegexpError
          RuntimeError
          ScriptError
          SecurityError
          Signal
          SignalException
          StandardError
          String
          Struct
          Symbol
          SyntaxError
          SystemCallError
          SystemExit
          SystemStackError
          Thread
          ThreadError
          ThreadGroup
          Time
          TrueClass
          TypeError
          UnboundMethod
          ZeroDivisionError
        ).freeze

        NAMESPACES_RUBY_200 = %w(
          ARGF
          ArgumentError
          Array
          BasicObject
          Bignum
          Binding
          Class
          Comparable
          Complex
          Continuation
          Data
          Dir
          ENV
          EOFError
          Encoding
          EncodingError
          Enumerable
          Enumerator
          Errno
          Exception
          FalseClass
          Fiber
          FiberError
          File
          FileTest
          Fixnum
          Float
          FloatDomainError
          GC
          Hash
          IO
          IOError
          IndexError
          Integer
          Interrupt
          Kernel
          KeyError
          LoadError
          LocalJumpError
          Marshal
          MatchData
          Math
          Method
          Module
          Mutex
          NameError
          NilClass
          NoMemoryError
          NoMethodError
          NotImplementedError
          Numeric
          Object
          ObjectSpace
          Proc
          Process
          Random
          Range
          RangeError
          Rational
          Regexp
          RegexpError
          RubyVM
          RuntimeError
          ScriptError
          SecurityError
          Signal
          SignalException
          StandardError
          StopIteration
          String
          Struct
          Symbol
          SyntaxError
          SystemCallError
          SystemExit
          SystemStackError
          Thread
          ThreadError
          ThreadGroup
          Time
          TracePoint
          TrueClass
          TypeError
          UnboundMethod
          ZeroDivisionError
        ).freeze

        NAMESPACES_RUBY_220 = %w(
          ArgumentError
          Array
          BasicObject
          Bignum
          Binding
          Class
          Comparable
          Complex
          ConditionVariable
          Continuation
          Data
          Dir
          ENV
          EOFError
          Encoding
          EncodingError
          Enumerable
          Enumerator
          Errno
          Exception
          FalseClass
          Fiber
          FiberError
          File
          FileTest
          Fixnum
          Float
          FloatDomainError
          GC
          Hash
          IO
          IOError
          IndexError
          Integer
          Interrupt
          Kernel
          KeyError
          LoadError
          LocalJumpError
          Marshal
          MatchData
          Math
          Method
          Module
          Mutex
          NameError
          NilClass
          NoMemoryError
          NoMethodError
          NotImplementedError
          Numeric
          Object
          ObjectSpace
          Proc
          Process
          Queue
          Random
          Range
          RangeError
          Rational
          Regexp
          RegexpError
          RubyVM
          RuntimeError
          ScriptError
          SecurityError
          Signal
          SignalException
          SizedQueue
          StandardError
          StopIteration
          String
          Struct
          Symbol
          SyntaxError
          SystemCallError
          SystemExit
          SystemStackError
          Thread
          ThreadError
          ThreadGroup
          Time
          TracePoint
          TrueClass
          TypeError
          UnboundMethod
          UncaughtThrowError
          ZeroDivisionError
        ).freeze

        NAMESPACES = (
          (
            NAMESPACES_RUBY_186 |
            NAMESPACES_RUBY_200 |
            NAMESPACES_RUBY_220
          # Remove Object because this is the global namespace and there are
          # other checks for this.
          ) - ['Object']
        ).freeze

        def namespaces
          NAMESPACES
        end

      end
    end
  end
end
