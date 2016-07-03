module Metaclass::Extension
  macro extended
    include ::Metaclass::ClassMacros

    {%
      is_root = !@type.superclass || !@type.superclass.constants.includes?("Metaclass")
    %}
    {% if is_root %}
      {%
        base = ::Metaclass::Base
        supertype = Nil
      %}
    {% else %}
      {%
        base = "#{@type.superclass.id}::Metaclass"
        supertype = @type.superclass
      %}
    {% end %}

    class Metaclass < ::{{base.id}}
      alias Supertype = ::{{@type.superclass.id}}
      alias Type = ::{{@type.id}}
      alias Supermetaclass = ::{{base.id}}

      {% if is_root %}
        IS_ROOT = true
      {% else %}
        IS_ROOT = false
      {% end %}

      def self.root?
        {{is_root}}
      end      
    end
  end
end
