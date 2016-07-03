require "./spec_helper"

# {%
#   if @type.superclass.class_name == "Foo"
#     # blah blah
#   else
#     # ...
#   end
# %}

# {% if @type.superclass.class_name == "Foo" %}
#   {%
#     # blah blah
#   %}
# {% else %}
#   {%
#     # ...
#   %}
# {% end %}

# alias OptionsType = NamedTuple(s: String, b: Bool)
# DEFAULT_OPTIONS = OptionsType.new(s: "default", b: false)
#
# # struct NamedTuple
# #   def to_h
# #     {% if T.empty? %}
# #       nil
# #     {% else %}
# #       {
# #         {% for key in T %}
# #           {{key.symbolize}} => self[{{key.symbolize}}].clone,
# #         {% end %}
# #       }
# #     {% end %}
# #   end
# # end
#
# def foo(**options)
#   puts OptionsType.from(DEFAULT_OPTIONS.to_h.merge(options.to_h))
# end
#
# foo

# struct NamedTuple
#   def merge(other)
#     T.from(to_h.merge(other.to_h))
#   end
# end
#
# class C
#   @options : NamedTuple(i: Int32, s: String, b: Bool)
#   DEFAULT_OPTIONS = {i: 1, s: "str", b: false}
#
#   def initialize(**options)
#     @options = DEFAULT_OPTIONS.merge(options)
#   end
# end
#
# C.new

# class C
#   @first : String
#   @second : String
#
#   def initialize(@first, @second)
#   end
# end
#
# class D < C
#   def initialize(alias = "default")
#     super "1st_arg", alias
#   end
# end

# abstract class ValueSet
#   alias ValuesType = NamedTuple(...)
#   @original_values : ValuesType
#   @values : Hash(...)
#
#   def initialize(**values)
#     @original_values = default_values.merge(values)
#     @values = @original_values.to_h
#   end
#
#   def reset
#     @values = @original_values.to_h
#   end
#
#   def diff
#     @original_values - @values
#   end
#
#   abstract def default_values
# end
#
# class Child < ValueSet
#   DEFAULT_VALUES = ValuesType(...)
#
#   def default_values
#     DEFAULT_VALUES
#   end
# end

# struct NamedTuple
#   def merge(other)
#     if h = to_h?
#       if other = other.to_h?
#         T.from(h.merge(other))
#       else
#         self
#       end
#     else
#       if other = other.to_h?
#
#         T.from(T.new.other)
#       end
#       T.from(other.empty? ? other : raise "Expected a hash with 1 keys"
#     end
#   end
#
#   def to_h?
#     {% unless T.empty? %}
#       {
#         {% for key in T %}
#           {{key.symbolize}} => self[{{key.symbolize}}].clone,
#         {% end %}
#       }
#     {% end %}
#   end
# end
#
# struct NamedTuple
#   def merge(other)
#     if h = to_h?
#       if other = other.to_h?
#         T.from(h.merge(other))
#       else
#         self
#       end
#     else
#       raise ArgumentError.new if other.to_h?
#       self
#     end
#   end
#
#   def to_h?
#     {% unless T.empty? %}
#       to_h
#     {% end %}
#   end
# end
#
# def foo(**tuple)
#    NamedTuple.new.merge(tuple)
# end
#
# puts foo a: 1
