class OffersController < ApplicationController
  include CurrentUserConcern
  before_action :set_offer, only: %i[ show update destroy ]
  before_action :authenticate_as_support, only: [:create, :update, :destroy]

  # GET /offers
  # GET /offers.json
  def index
    @offers = Offer.all.reverse
    render json: offers_with_images_as_json(@offers)
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
    render json: offer_with_images_as_json(@offer)
  end

  # POST /offers
  # POST /offers.json
  def create
    @offer = @current_user.offers.new(offer_params.except(:images))
    images = params.dig(:offer, :images)
    if images
      images.each do |image|
        @offer.images.attach(image)
      end
    end


    if @offer.save
      render json: offer_with_images_as_json(@offer), status: :created, location: @offer
    else
      render json: @offer.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /offers/1
  # PATCH/PUT /offers/1.json
  def update
    images = params.dig(:offer, :images)
    if images
      @offer.images.purge
      images.each do |image|
        @offer.images.attach(image)
      end
    end
    if @offer.update(offer_params)
      render json: @offer, status: :ok, location: @offer
    else
      render json: @offer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    @offer.images.purge
    @offer.destroy!

    render json: {message: "Offer has been deleted"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def offer_params
      params.require(:offer).permit(:title, :description, :address, :user_id, images: [])
    end

    # Returns offer with images 
    def offer_with_images_as_json(offer)
      offer.as_json(include: :images).merge(
        images: offer.images.map do |image|
          url_for(image)
        end
      )
    end
    
    # Returns offers with images
    def offers_with_images_as_json(offers)
      offers.map do |offer| 
        offer_with_images_as_json(offer)
      end
    end
end
