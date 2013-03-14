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

class Calibration < ActiveRecord::Base
   attr_accessible :filename, :cal_date,  :expiration_date, :range_max, :range_min, :sensor_id
   belongs_to :sensor
   validates :sensor_id, presence: true
end
