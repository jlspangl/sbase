class SensorsController < ApplicationController
  respond_to :html, :csv

  def index
    @sensors = Sensor.paginate(page: params[:page])
    respond_with @sensors
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


end
