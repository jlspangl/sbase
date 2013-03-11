module SensorsHelper

  def control_number(sensor)
    if sensor.ecn.blank?
      "#{sensor.mcn}"
    elsif sensor.mcn.blank?
      "#{sensor.ecn}"
    else
      "#{sensor.mcn}/#{ensor.ecn}"
    end
  end

end
