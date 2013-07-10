class CalibrationImportsController < ApplicationController

  def new
    @calibration_import = CalibrationImport.new
  end    #new

  def create
    if params[:calibration_import]
      @calibration_import = CalibrationImport.new(params[:calibration_import])
      if (calibration_id = @calibration_import.save)
        @calibration_import.upload
        redirect_to verify_calibrations_path(:id => calibration_id)
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