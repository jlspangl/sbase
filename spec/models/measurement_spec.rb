# == Schema Information
#
# Table name: measurements
#
#  id             :integer          not null, primary key
#  sensor_id      :integer
#  calibration_id :integer
#  position       :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Measurement do
  pending "add some examples to (or delete) #{__FILE__}"
end
