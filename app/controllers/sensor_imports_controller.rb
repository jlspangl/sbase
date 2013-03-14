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
      flash.now[:error] = "No file to import. Please select a spreadsheet using the file chooser."
      render :new
    end
  end
end