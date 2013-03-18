class CalibrationsController < ApplicationController

  #def new
  #   @calibration = Calibration.new
  #end
  #
  #
  #def create
  #  @calibration = Calibration.new(params[:calibration])
  #  if @calibration.save
  #    sign_in @calibration
  #    flash[:success] = "Welcome #{@calibration.login_name}!"
  #    redirect_to @calibration
  #  else
  #    render 'new'
  #  end
  #end

  def verify
    @calibration = Calibration.find(params[:id])
    @sensors = params[:sensor_ids].map { |id| Sensor.find(id)}
  end

  def edit
    @calibration = Calibration.find(params[:id])
  end


  def update
    if params["commit"] .eql?("Cancel")
      calibration = Calibration.find(params[:id])
      #delete excel file
      calibration.destroy()
    elsif @calibration.update_attributes(params[:calibration])
        flash[:success] = "The calibration was successfully uploaded into the database."
    else
        render 'edit'
    end
    redirect_to root_url
  end




end
