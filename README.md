# Metaclass

A Crystal library for manipulating class-level definitions.

[![Build Status](https://travis-ci.org/mosop/metaclass.svg?branch=master)](https://travis-ci.org/mosop/metaclass)

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

### Predicate

```crystal
require "metaclass/object"

class Misc
  metaclass!
  class_getter? exists = true
  class_setter? promise_broken = false
  class_property? happy = false, neg: unhappy
end

Misc.exists? # => true
Misc.exists! # => raises error (getter only)
Misc.promise_broken!
Misc.promise_broken? # raises error (setter only)
Misc.happy? # => false
Misc.happy!
Misc.happy? # => true
Misc.unhappy!
Misc.happy? # => false
```

### Computed Property

```crystal
require "metaclass/object"

class Constant
  metaclass!
  class_getter uuid : String { SecureRandom.uuid }
end

class Inconstant
  metaclass!
  class_getter uuid : String, memo: false { SecureRandom.uuid }
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
    {:a => "a"}
  end
end

class B < A
  metaclass!
  inherited_class_getter inheritance do |parent|
    parent.merge(:b => "b")
  end
end

A.inheritance # => {:a => "a"}
B.inheritance # => {:a => "a", :b => "b"}
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
