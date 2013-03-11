class SensorImportsController < ApplicationController
  def new
    @sensor_import = SensorImport.new
  end

  def create
    @sensor_import = SensorImport.new(params[:sensor_import])
    if @sensor_import.save
      redirect_to sensors_url, notice: "Imported sensors successfully."
    else
      render :new
    end
  end
end