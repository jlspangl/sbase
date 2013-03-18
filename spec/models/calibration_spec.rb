# == Schema Information
#
# Table name: calibrations
#
#  id               :integer          not null, primary key
#  orig_filename    :string(255)
#  measurement_unit :string(255)
#  calibration_date :date
#  expiration_date  :date
#  calibration_max  :float            default(0.0)
#  calibration_min  :float            default(0.0)
#  range            :float            default(0.0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  folder           :string(255)
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
