class OffersController < ApplicationController
  before_action :set_offer, only: %i[ show update destroy ]

  # GET /offers
  # GET /offers.json
  def index
    @offers = Offer.all
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
    render json: @offer.as_json(include: :images).merge(
      images: @offer.omages.map do |image|
        url_for(image)
      end
    )
  end

  # POST /offers
  # POST /offers.json
  def create
    @offer = Offer.new(offer_params.except(:images))

    images = params[:offer][:images]
    if images
      images.each do |image|
        @offer.images.attach(image)
      end
    end

    if @offer.save
      render :show, status: :created, location: @offer
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
      params.require(:offer).permit(:title, :description, :address, images: [])
    end
end
