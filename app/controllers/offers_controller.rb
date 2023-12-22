class OffersController < ApplicationController
  before_action :set_offer, only: %i[ show update destroy ]
  include CurrentUserConcern
  before_action :authenticate_as_support, only: [:create, :update, :destroy]

  def authenticate_as_support
    authenticate "support"
  end

  # GET /offers
  # GET /offers.json
  def index
    @offers = Offer.all
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
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
      # images = params[:offer][:images]
      # if images
      #   images.each do |image|
      #     @offer.images.attach(image)
      #   end
      # end


    if @offer.save
      render json: @offer, status: :created, location: @offer
    else
      render json: @offer.errors, status: :unprocessable_entity
    end
  end

  # def render_unauthorized
  #   return render json: { status: 401, message: "User is not logged in." } , status: 401 if @current_user.nil?
  #   return render json: { status: 403, message: "User is not with a support role, not pormissions to create offers." } , status: 403 if !@current_user.role_support?

  #   # Displays the Unauthorized message
  #   render json: JSON.pretty_generate({ 
  #     error: { 
  #       type: "unauthorized",
  #       message: "This page cannot be accessed without a valid API key."
  #       } 
  #     }), status: 401
  # end

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
      params.require(:offer).permit(:title, :description, :address, :user_id, images: [])
    end
end
