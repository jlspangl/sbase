# == Schema Information
#
# Table name: calibrations
#
#  id              :integer          not null, primary key
#  filename        :string(255)
#  cal_date        :date
#  expiration_date :date
#  range_max       :float            default(0.0)
#  range_min       :float            default(0.0)
#  sensor_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Calibration do

  let(:sensor) { FactoryGirl.create(:sensor) }
  before do
    @calibration = Calibration.new(filename:"foo.xls", sensor_id: sensor.id)
  end
  subject { @calibration }

  it { should respond_to(:filename) }
  it { should respond_to(:expiration_date) }
  it { should respond_to(:cal_date) }
  it { should respond_to(:range_max) }
  it { should respond_to(:range_min) }
  it { should respond_to(:sensor_id) }
  its(:sensor) { should == sensor }
end
