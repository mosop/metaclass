module Metaclass::MetaclassMacro
  macro metaclass!
    extend ::Metaclass::Extension
  end
end
