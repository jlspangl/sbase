module CalibrationsHelper

  def get_range_hint(c)
    #"Range from minimum of #{c.calibration_min} to maximum of #{c.calibration_max}"
    "Minimum of #{c.calibration_min} to Maximum of #{c.calibration_max}; Mode: #{c.mode_to_string}"
  end

end
