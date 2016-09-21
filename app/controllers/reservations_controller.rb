require 'oj'
require "uri"
require "net/http"

class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]
  after_action :call_button, only: [:update]
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    if(params['data'])
        reservation_hash = Oj.load(params['data']);      
        @reservation = Reservation.new(reservation_am: reservation_hash["reservation_am"], reservation_pm: reservation_hash["reservation_pm"])
        #@reservation = Reservation.new(reservation_hash)
    else
        @reservation = Reservation.new(reservation_params)
    end 
  

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    respond_to do |format|
      if !@reservation
         if(params['data'])
            reservation_hash = Oj.load(params['data'])
            @reservation = Reservation.find(reservation_hash[:id])
            if @reservation.update(:device_id: reservation_hash["device_id"], reservation_am: reservation_hash["reservation_am"], reservation_pm: reservation_hash["reservation_pm"])
              format.json { render :show, status: :ok, location: @reservation }
            end 
         end
      elsif @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
      
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  # POST on button device to update leds
  def call_button
    if @reservation && @reservation.device_id
      if @reservation.reservation_am
      ##calling function to udpate leds
        x = Net::HTTP.post_form(URI.parse('https://api.particle.io/v1/devices/'+@reservation.device_id+'/setBtnLeds'),'access_token'=>'4b481cdd6ca24ffdd5ee6e4adb78c4dc61cc88fa', 'arg'=> 'am')        
      end 
      if @reservation.reservation_pm
      ##calling function to udpate leds
       x = Net::HTTP.post_form(URI.parse('https://api.particle.io/v1/devices/'+@reservation.device_id+'/setBtnLeds'),'access_token'=>'4b481cdd6ca24ffdd5ee6e4adb78c4dc61cc88fa', 'arg'=> 'pm') 
      end
      if @reservation.reservation_am && @reservation.reservation_pm
      ##calling function to udpate leds
      x = Net::HTTP.post_form(URI.parse('https://api.particle.io/v1/devices/'+@reservation.device_id+'/setBtnLeds'),'access_token'=>'4b481cdd6ca24ffdd5ee6e4adb78c4dc61cc88fa', 'arg'=> 'ampm')
      end  
    end 
  end 
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:desk_id, :description, :reservation_date, :reservation_pm, :reservation_am, :event, :data, :published_at, :coreid)
    end
end
