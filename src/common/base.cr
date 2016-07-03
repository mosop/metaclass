require "./metaclass_macro"

module Metaclass
  class Base
    include ::Metaclass::MetaclassMacro

    def self.__yield(*args)
      yield *args
    end

    macro inherited
    end
  end
end
