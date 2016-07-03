require "../spec_helper"

module Metaclass::InheritableVariablesFeature
  class A
    Metaclass.metaclass!

    class_getter inheritance : Hash(Symbol, String) do
      {:a => "a"}
    end
  end

  class B < A
    Metaclass.metaclass!

    inherited_class_getter inheritance do |parent|
      parent.merge({:b => "b"})
    end
  end

  it name do
    A.inheritance.should eq({:a => "a"})
    B.inheritance.should eq({:a => "a", :b => "b"})
  end
end
