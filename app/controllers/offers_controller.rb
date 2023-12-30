class OffersController < ApplicationController
  before_action :set_offer, only: %i[ show update destroy ]
  include CurrentUserConcern
  before_action :authenticate_as_support, only: [:create, :update, :destroy]

  # GET /offers
  # GET /offers.json
  def index
    @offers = Offer.all
    @offers.each do |offer| 
      # debugger
      offer.as_json(include: :images).merge(
        images: offer.images.map do |image|
          url_for(image)
        end
      )
    end
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
    # debugger
    render json: @offer.as_json(include: :images).merge(
      images: @offer.images.map do |image|
        url_for(image)
      end
    )
  end

  # POST /offers
  # POST /offers.json
  def create
    @offer = @current_user.offers.new(offer_params)
    images = params.dig(:offer, :images)
    if images
      images.each do |image|
        @offer.images.attach(image)
      end
    end


    if @offer.save
      render json: @offer, status: :created, location: @offer
    else
      render json: @offer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /offers/1
  # PATCH/PUT /offers/1.json
  def update
    if @offer.update(offer_params)
      render :show, status: :ok, location: @offer
    else
      render json: @offer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    @offer.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def offer_params
      params.require(:offer).permit(:title, :description, :address, :user_id)
    end
end
