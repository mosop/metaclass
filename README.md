# Metaclass

A Crystal library for manipulating class-level definitions.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  metaclass:
    github: mosop/metaclass
```

## Features

<a name="features"></a>

### Class Property

```crystal
require "metaclass/object"

class Misc
  metaclass!
  class_getter faces = {:smile => ":)", :frown => ":("}
  class_setter passcode = Random.rand(10000)
  class_property movie = "Jaws"
end

Misc.faces # => {:smile => ":)", :frown => ":("}
Misc.faces = {:smile => ":D", :frown => ":{"} # raises error (getter only)
Misc.passcode = Random.rand(10000)
Misc.passcode # raises error (setter only)
Misc.movie # => "Jaws"
Misc.movie = "La Strada"
Misc.movie # => "La Strada"
```

### Initializer

```crystal
require "metaclass/object"

class Constant
  metaclass!
  class_getter uuid : Int32 { SecureRandom.uuid }
end

class Inconstant
  metaclass!
  class_getter uuid : Int32, memo: false { SecureRandom.uuid }
end

Constant.uuid == Constant.uuid # => true
Inconstant.uuid != Inconstant.uuid # => true
```

### Variable Inheritance

```crystal
require "metaclass/object"

class A
  metaclass!
  class_getter inheritance, Hash(Symbol, String) do
    {key: "value"}
  end
end

class B < A
  metaclass!
  inherit_class_variable inheritance do |parent|
    parent.merge(key2: "value2")
  end
end
```

## Usage

```crystal
require "metaclass/object"

class A
  metaclass!
end
```

Or more clean:

```crystal
require "metaclass"

class A
  Metaclass.metaclass!
end
```

And see [Features](#features)

## Contributing

1. Fork it ( https://github.com/mosop/metaclass/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [mosop](https://github.com/mosop) - creator, maintainer
