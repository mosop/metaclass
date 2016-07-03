require "../spec_helper"
require "secure_random"

module MetaclassInitializerFeature
  class Constant
    metaclass!
    class_getter uuid : String { SecureRandom.uuid }
  end

  class Inconstant
    metaclass!
    class_getter uuid : String, memo: false { SecureRandom.uuid }
  end

  it name do
    Constant.uuid.should eq Constant.uuid
    Inconstant.uuid.should_not eq Inconstant.uuid
  end
end
