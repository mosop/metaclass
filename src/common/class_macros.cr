module Metaclass::ClassMacros
  macro __define_class_attribute(decl, inherited = nil)
    {%
      inherited = false if inherited.class_name == "NilLiteral"

      if decl.class_name == "TypeDeclaration"
        name = decl.var
        type = decl.type
        value = decl.value
      elsif decl.class_name == "Assign"
        name = decl.target
        type = nil
        value = decl.value
      elsif decl.class_name == "Call"
        name = decl.name
        type = nil
        value = nil
      else
        raise "unknown node: #{decl}"
      end

      if !type && !inherited && value.class_name != "BoolLiteral" && !value
        raise "At least type or value is needed: #{name.id}"
      end %}

    {%
      pascal = name.id.split("_").map{|i| i.capitalize}.join("")
    %}

    {% unless Metaclass.has_constant?("#{name.id.upcase.id}_VARIABLE_DEFINED") %}
      class Metaclass
        {{name.id.upcase.id}}_VARIABLE_DEFINED = true

        {% if type %}
          alias {{pascal.id}}VariableType = {{type}}
        {% end %}

        @@{{name.id}}_variable_is_set = false
        def self.{{name.id}}_variable_is_set?
          @@{{name.id}}_variable_is_set
        end
        def self.{{name.id}}_variable_is_set!
          @@{{name.id}}_variable_is_set = true
        end
      end

      {% if type %}
        {% if value %}
          @@{{name.id}} : {{type}} = {{value}}
        {% else %}
          @@{{name.id}} : {{type}} | Nil
        {% end %}
      {% elsif inherited %}
        {% if value %}
          @@{{name.id}} : Metaclass::{{pascal.id}}VariableType = {{value}}
        {% else %}
          @@{{name.id}} : Metaclass::{{pascal.id}}VariableType | Nil
        {% end %}
      {% else %}
        @@{{name.id}} = {{value}}
      {% end %}
    {% end %}
  end

  macro class_property(decl, memo = true, &block)
    class_getter {{decl}}, memo: memo {{block}}
    class_setter {{decl}}
  end

  macro class_getter(decl, memo = true, inherited = false, block_arg = nil, &block)
    __define_class_attribute {{decl}}, inherited: {{inherited}}
    {%
      if decl.class_name == "TypeDeclaration"
        name = decl.var
      elsif decl.class_name == "Assign"
        name = decl.target
      elsif decl.class_name == "Call"
        name = decl.name
      else
        raise "unknown node: #{decl}"
      end %}
    {%
      pascal = name.id.split("_").map{|i| i.capitalize}.join("")
    %}
    def self.{{name.id}}
      {% if block %}
        {% if memo %}
          if Metaclass.{{name.id}}_variable_is_set?
            @@{{name.id}} as Metaclass::{{pascal.id}}VariableType
          else
            Metaclass.{{name.id}}_variable_is_set!
            {% if block_arg %}
              @@{{name.id}} = Metaclass.__yield {{block_arg}} {{block}}
            {% else %}
              @@{{name.id}} = Metaclass.__yield {{block}}
            {% end %}
          end
        {% else %}
          {% if block_arg %}
            Metaclass.__yield {{block_arg}} {{block}}
          {% else %}
            Metaclass.__yield {{block}}
          {% end %}
        {% end %}
      {% else %}
        @@{{name.id}}
      {% end %}
    end
  end

  macro class_setter(decl)
    __define_class_attribute {{decl}}
    {%
      if decl.class_name == "TypeDeclaration"
        name = decl.var
      elsif decl.class_name == "Assign"
        name = decl.target
      elsif decl.class_name == "Call"
        name = decl.name
      else
        raise "unknown node: #{decl}"
      end %}
    def self.{{name.id}}=(value)
      @@{{name.id}} = value
    end
  end

  macro inherited_class_getter(decl, &block)
    {%
      if decl.class_name == "TypeDeclaration"
        name = decl.var
      elsif decl.class_name == "Assign"
        name = decl.target
      elsif decl.class_name == "Call"
        name = decl.name
      elsif decl.class_name == "Var"
        name = decl
      end %}

    class_getter {{decl}}, inherited: true, block_arg: Metaclass::Supertype.{{name.id}} {{block}}
  end
end
