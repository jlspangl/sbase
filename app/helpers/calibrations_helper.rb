module CalibrationsHelper

  def sensor_label(sensor)
    a = []
    a << sensor.mcn unless sensor.mcn.blank?
    a << sensor.ecn unless sensor.ecn.blank?
    a << sensor.serial_no unless sensor.serial_no.blank?
    s = ""
    a.each {|x| s << "#{x} #{'/ ' unless a.last==x}"}
    s
  end

end
