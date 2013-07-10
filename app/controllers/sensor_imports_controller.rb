class SensorImportsController < ApplicationController
  def new
    @sensor_import = SensorImport.new
  end

  def create
    if   params[:sensor_import]
      @sensor_import = SensorImport.new(params[:sensor_import])
      if @sensor_import.save
        redirect_to sensors_url, notice: "Imported sensors successfully."
      else
        render :new
      end
    else
      @sensor_import = SensorImport.new
      flash.now[:error] = "Please use the file-chooser to select the excel file."
      render :new
    end
  end
end