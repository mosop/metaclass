module Metaclass::Extension
  macro extended
    include ::Metaclass::ClassMacros
    __define_metaclass_class
  end
end
