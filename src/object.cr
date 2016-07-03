require "./metaclass"

class Object
  include ::Metaclass::MetaclassMacro
end
