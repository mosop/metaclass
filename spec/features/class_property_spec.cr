require "../spec_helper"

module MetaclassClassPropertyFeature
  class Misc
    metaclass!
    class_getter faces = {:smile => ":)", :frown => ":("}
    class_setter passcode : Int32 = Random.rand(10000)
    class_property movie = "Jaws"
  end

  it name do
    Misc.faces.should eq({:smile => ":)", :frown => ":("})
    Misc.responds_to?(:"faces=").should be_false
    Misc.passcode = Random.rand(10000)
    Misc.responds_to?(:passcode).should be_false
    Misc.movie.should eq "Jaws"
    Misc.movie = "La Strada"
    Misc.movie.should eq "La Strada"
  end
end
