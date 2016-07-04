module Metaclass::ClassMacros
  macro __define_metaclass_class
    {% unless @type.constants.includes?("Metaclass".id) %}
      {%
        is_root = !@type.superclass || !@type.superclass.constants.includes?("Metaclass".id)
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

        IS_ROOT = {{is_root}}

        def self.root?
          {{is_root}}
        end
      end
    {% end %}
  end

  macro __define_class_attribute(decl, inherited = nil, predicate = nil)
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
      end %}
    {%
      pascal = name.id.split("_").map{|i| i.capitalize}.join("")
    %}
    {%
      if !type && (predicate)
        type = "::Bool"
      end %}
    {%
      defined_status = if predicate
        "PREDICATE_VARIABLE_DEFINED__#{name.id.upcase}"
      else
        "VARIABLE_DEFINED__#{name.id.upcase}"
      end %}
    {%
      variable_type = if predicate
        "PredicateVariableType_#{pascal.id}"
      else
        "VariableType_#{pascal.id}"
      end %}
    {%
      variable_name = if predicate
        "#{name.id}__predicate"
      else
        "#{name.id}"
      end %}
    {% unless Metaclass.has_constant?(defined_status) %}
      __define_metaclass_class
      class Metaclass
        {{defined_status.id}} = true

        {% if type %}
          alias {{variable_type.id}} = {{type.id}}
        {% end %}

        @@there_is__{{variable_name.id}} = false
        def self.there_is__{{variable_name.id}}?
          @@there_is__{{variable_name.id}}
        end
        def self.there_is__{{variable_name.id}}!
          @@there_is__{{variable_name.id}} = true
        end
      end
      {% if type %}
        {% if value.class_name != "Nop" %}
          @@{{variable_name.id}} : {{type.id}} = {{value}}
        {% else %}
          @@{{variable_name.id}} : {{type.id}} | Nil
        {% end %}
      {% elsif inherited %}
        {% if value.class_name != "Nop" %}
          @@{{variable_name.id}} : Metaclass::{{variable_type.id}} = {{value}}
        {% else %}
          @@{{variable_name.id}} : Metaclass::{{variable_type.id}} | Nil
        {% end %}
      {% else %}
        @@{{variable_name.id}} = {{value}}
      {% end %}
    {% end %}
  end

  macro class_property(decl, memo = nil, &block)
    class_getter {{decl}}, memo: {{memo}} {{block}}
    class_setter {{decl}}
  end

  macro __define_class_getter_method(typename, method_name, variable_name, memo = nil, block_arg = nil, &block)
    def self.{{method_name.id}}
      {% if block %}
        {% if memo %}
          if Metaclass.there_is__{{variable_name.id}}?
            @@{{variable_name.id}} as Metaclass::{{typename.id}}
          else
            Metaclass.there_is__{{variable_name.id}}!
            {% if block_arg %}
              @@{{variable_name.id}} = Metaclass.__yield({{block_arg}}) {{block}}
            {% else %}
              @@{{variable_name.id}} = Metaclass.__yield {{block}}
            {% end %}
          end
        {% else %}
          {% if block_arg %}
            Metaclass.__yield({{block_arg}}) {{block}}
          {% else %}
            Metaclass.__yield {{block}}
          {% end %}
        {% end %}
      {% else %}
        @@{{variable_name.id}}
      {% end %}
    end
  end

  macro __define_class_getter(decl, memo = nil, block_arg = nil, predicate = nil, &block)
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
    {%
      if predicate
        variable_type = "PredicateVariableType_#{pascal.id}"
        method_name = "#{name.id}?"
        variable_name = "#{name.id}__predicate"
      else
        variable_type = "VariableType_#{pascal.id}"
        method_name = name
        variable_name = name
      end %}
    __define_class_getter_method {{variable_type}}, {{method_name}}, {{variable_name}}, memo: {{memo}}, block_arg: {{block_arg}} {{block}}
  end

  macro class_getter(decl, memo = nil, inherited = nil, block_arg = nil, predicate = nil, &block)
    {%
      memo = true if memo.class_name == "NilLiteral"
    %}
    __define_class_attribute {{decl}}, inherited: {{inherited}}, predicate: {{predicate}}
    __define_class_getter {{decl}}, memo: {{memo}}, block_arg: {{block_arg}}, predicate: {{predicate}} {{block}}
  end

  macro __define_class_setter_method(method_name, variable_name, memo = nil, block_arg = nil, &block)
    {% if block %}
      def self.{{method_name.id}}
        {% if block_arg %}
          @@{{variable_name.id}} = Metaclass.__yield({{block_arg}}) {{block}}
        {% else %}
          @@{{variable_name.id}} = Metaclass.__yield {{block}}
        {% end %}
      end
    {% else %}
      def self.{{method_name.id}}=(value)
        @@{{variable_name.id}} = value
      end
    {% end %}
  end

  macro __define_class_setter(decl, predicate = nil, block_arg = nil, &block)
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
      if predicate
        method_name = "#{name.id}!"
        variable_name = "#{name.id}__predicate"
      else
        method_name = name
        variable_name = name
      end %}
    __define_class_setter_method {{method_name}}, {{variable_name}}, block_arg: {{block_arg}} {{block}}
  end

  macro class_setter(decl, predicate = nil, block_arg = nil, &block)
    __define_class_attribute {{decl}}, predicate: {{predicate}}
    __define_class_setter {{decl}}, predicate: {{predicate}}, block_arg: {{block_arg}} {{block}}
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

  macro class_property?(decl, memo = nil, neg = nil, &block)
    class_getter? {{decl}}, memo: {{memo}} {{block}}
    class_setter? {{decl}}, neg: {{neg}}
  end

  macro class_getter?(decl, memo = nil, &block)
    class_getter {{decl}}, memo: {{memo}}, predicate: true {{block}}
  end

  macro class_setter?(decl, memo = nil, neg = nil)
    {%
      memo = false if memo.class_name == "NilLiteral"
    %}
    class_setter {{decl}}, predicate: true { true }
    {% if neg %}
      class_setter {{neg}}, predicate: true { false }
    {% end %}
  end
end
