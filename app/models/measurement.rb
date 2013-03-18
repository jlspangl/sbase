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

class Measurement < ActiveRecord::Base
  #attr_accessible :calibration_id, :position, :sensor_id
  belongs_to :calibration
  belongs_to :sensor

  #The order that calibrations are associated with sensors is  saved
  #because the first association (position=0) is the sensor that is
  #used to name the directory where the calibration spreadsheet
  #is stored.
  before_save :create_position

  private

  def create_position
    self.position = Calibration.find(calibration_id).sensors.length
  end

end
