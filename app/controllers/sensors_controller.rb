class SensorsController < ApplicationController
  respond_to :html, :csv
  #helper_method :sort_column, :sort_direction

  def index
    @search = Sensor.search(params[:q])
    @sensors = @search.result(:distinct => true)
    @sensors = @sensors.paginate(:page => params[:page],  :per_page => 15)
  end

  def show
    @sensor  = Sensor.find(params[:id])
  end

  def new
    @sensor = Sensor.new
  end


  def create
    @sensor = Sensor.new(params[:sensor])
    if @sensor.save
      flash[:success] = "One sensor was added to the database"
      redirect_to sensors_url
    else
      render 'new'
    end
  end

  def edit
    @sensor = Sensor.find(params[:id])
  end

  def update
    @sensor = Sensor.find(params[:id])
    if @sensor.update_attributes(params[:sensor])
      flash[:success] = "Sensor updated"
      redirect_to sensors_url
    else
      render 'edit'
    end
  end

  def destroy
    Sensor.find(params[:id]).destroy
    flash[:success] = "Sensor destroyed."
    redirect_to sensors_url
  end

  #private
  #
  #def sort_column
  #  Sensor.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  #end
  #
  #def sort_direction
  #  %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  #end

end
