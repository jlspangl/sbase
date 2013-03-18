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

class Calibration < ActiveRecord::Base
   attr_accessible :orig_filename, :calibration_date,  :measurement_unit, :expiration_date, :calibration_max, :calibration_min, :range
   has_many :measurements
   has_many  :sensors, :through => :measurements
end
