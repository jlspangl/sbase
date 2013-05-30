# == Schema Information
#
# Table name: calibrations
#
#  id               :integer          not null, primary key
#  orig_filename    :string(255)
#  measurement_unit :string(255)
#  caldate          :date
#  expdate          :date
#  calibration_max  :float            default(0.0)
#  calibration_min  :float            default(0.0)
#  range            :float            default(0.0)
#  dirty            :boolean          default(TRUE)
#  folder           :string(255)
#  string           :string(255)
#  mode             :integer
#  integer          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Calibration < ActiveRecord::Base
   attr_accessible :orig_filename, :calibration_date,  :measurement_unit, :expiration_date,
                   :calibration_max, :calibration_min, :range
   has_many :measurements
   has_many  :sensors, :through => :measurements
   UNIT_CHOICES = %w(lbf  N oz g in ft cm mm m um undefined)

   def before_save
       set_mode
   end


   def mode_to_string
    case mode
      when 1 then '+/-'
      when 2 then '-'
      when 3 then '+'
      else 'undefined'
    end
  end

  def set_mode
    if (self.calibration_min < 0 && self.calibration_max > 0)
      self.mode = 1
    elsif  (self.calibration_min < 0 && self.calibration_max <= 0)
      self.mode = 2
    elsif  (self.calibration_min >=0 && self.calibration_max > 0)
      self.mode = 3
    else
      self.mode = 0
    end
  end

end
