require "../spec_helper"

module PredicateFeature
  class Misc
    metaclass!
    class_getter? exists = true
    class_setter? promise_broken = false
    class_property? happy = false, neg: unhappy
  end

  it name do
    Misc.exists?.should be_true
    Misc.promise_broken!
    Misc.responds_to?(:"promise_broken?").should be_false
    Misc.happy?.should be_false
    Misc.happy!
    Misc.happy?.should be_true
    Misc.unhappy!
    Misc.happy?.should be_false
  end
end
