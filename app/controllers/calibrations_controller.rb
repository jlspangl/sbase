class CalibrationsController < ApplicationController
  respond_to :html, :csv
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
  end


  def index

    #fix search parameters so that query is for
    #gteq calibration date and lteq expiration date
    if (params[:q])
       params[:q]["expdate_gteq(1i)"] = params[:q]["caldate_lteq(1i)"]
       params[:q]["expdate_gteq(2i)"] = params[:q]["calidate_lteq(2i)"]
       params[:q]["expdate_gteq(3i)"] = params[:q]["caldate_lteq(3i)"]
    end

    @search = Calibration.search(params[:q])
    @calibrations = @search.result(:distinct => true)
    @calibrations = @calibrations.paginate(:page => params[:page], :per_page => 5)
  end

  def edit
    @calibration = Calibration.find(params[:id])
  end


  def update
    @calibration = Calibration.find(params[:id])
    if params["commit"] .eql?("Cancel")
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
