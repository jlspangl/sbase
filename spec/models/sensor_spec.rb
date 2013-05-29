# == Schema Information
#
# Table name: sensors
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  category   :string(255)
#  ecn        :string(255)
#  mcn        :string(255)
#  model      :string(255)
#  serial     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag        :string(255)
#

require 'spec_helper'

describe Sensor do
  before { @sensor = Sensor.new(name: "LVD TRANSDUCER",
                                category: "unknown",
                                model: "0246-0000",
                                serial: 4601,
                                mcn: "A024621") }


  subject { @sensor }

  it { should respond_to(:name) }
  it { should respond_to(:category) }
  it { should respond_to(:ecn) }
  it { should respond_to(:mcn) }
  it { should respond_to(:model) }
  it { should respond_to(:serial) }

  describe "when both MCN and ECN are not present" do
    before do
      @sensor.ecn = ""
      @sensor.mcn = ""
    end
    it { should_not be_valid }
  end

  describe "when both MCN and ECN are present" do
    before do
      @sensor.ecn = "2941"
      @sensor.mcn = "A024621"
    end
    it { should be_valid }
  end

  describe "when 2 ecns are blank" do
    before do
      @sensor.ecn = ""
      sensor_with_same_ecn = @sensor.dup
      sensor_with_same_ecn.ecn = ""
      sensor_with_same_ecn.mcn = "9999"
      sensor_with_same_ecn.serial = ""
    end
    it { should be_valid }
  end


  describe "when 2 ecns are same" do
    before do
      @sensor.ecn = "29421"
      sensor_with_same_ecn = @sensor.dup
      sensor_with_same_ecn.ecn = @sensor.ecn
      sensor_with_same_ecn.mcn = "8888"
      sensor_with_same_ecn.serial = ""
      sensor_with_same_ecn.save
    end
    it { should_not be_valid }
  end

end
