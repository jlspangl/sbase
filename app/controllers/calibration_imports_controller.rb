class CalibrationImportsController < ApplicationController

  def new
    @calibration_import = CalibrationImport.new
  end    #new

  def create
    if params[:calibration_import]

      @calibration_import = CalibrationImport.new(params[:calibration_import])
      if @calibration_import.save
        redirect_to calibrations_url, notice: 'Imported calibration successfully.'
      else
        render :new
      end

    else
      @calibration_import = CalibrationImport.new
      flash.now[:error] = "No file to import. Please select a Calibration Spreadsheet using the file chooser."
      render :new
    end
  end  #create


end   #CalibrationImportsController