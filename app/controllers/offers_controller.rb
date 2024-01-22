class OffersController < ApplicationController
  include CurrentUserConcern
  before_action :authenticate, only: [:contact]
  before_action :authenticate_as_provider, only: [:create, :my, :update, :destroy]
  before_action :set_offer, only: %i[ show contact update destroy ]

  # GET /offers
  # GET /offers.json
  def index
    @offers = Offer.all.reverse
    if params[:filters]
      @filters = params[:filters].class == String ? JSON.parse(params[:filters], {:symbolize_names=>true}) : params[:filters]
      @offers = filter_if_attribiute_contain_text(:address, @offers, @filters)
      @offers = filter_if_given_array_contains_attribiute(:category, :categories, @offers, @filters)
      @offers = filter_if_attribiute_is_between_values(:prize, @offers, @filters)
    end
    render json: offers_with_images_as_json(@offers)
  end

  # GET /offers_my
  # GET /offers_my.json
  def my
    @offers = @current_user.provider.offers.order(created_at: :desc)
    render json: offers_with_images_as_json(@offers)
  end

  # GET /offers/1
  # GET /offers/1.json
  def show
    render json: offer_with_images_as_json(@offer)
  end

  # GET /offers/1/contact
  # GET /offers/1/contact.json
  def contact
    result = offer_and_user_contact(@offer)
    render json: result, status: 200 
  end

  # POST /offers
  # POST /offers.json
  def create
    @offer = @current_user.provider.offers.new(offer_params.except(:images))
    images = params.dig(:offer, :images)
    if images
      images.each do |image|
        @offer.images.attach(image)
      end
    end


    if @offer.save
      render json: offer_with_images_as_json(@offer), status: :created, location: @offer
    else
      render json: @offer.errors.full_messages, status: :unprocessable_entity
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
      render json: @offer.errors.full_messages, status: :unprocessable_entity
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
      params.require(:offer).permit(:title, :description, :address, :user_id, :category, :prize, images: [])
    end

    def filters_params
      params.require(:filters)
    end

    # Returns offer with images 
    def offer_with_images_as_json(offer)
      offer.as_json(include: :images).merge(
        images: offer.images.map do |image|
          url_for(image.variant(:full_hd))
        end
      )
    end
    
    # Returns offers with images
    def offers_with_images_as_json(offers)
      offers.map do |offer| 
        offer_with_images_as_json(offer)
      end
    end

    # Filters for address, category and prize

    def filter_if_attribiute_contain_text(attribiute_name, offers, filters)
      if filters[attribiute_name]
        offers.filter {|offer| offer[attribiute_name].downcase.include?(filters[attribiute_name].downcase)}
      else
        offers
      end
    end
  
    def filter_if_given_array_contains_attribiute(attribiute_name, params_name, offers, filters)
      if filters[params_name] && !filters[params_name].empty? 
        offers.filter {|offer| filters[params_name].include?(offer[attribiute_name])}
      else
        offers
      end
    end
  
    def filter_if_attribiute_is_between_values(attribiute_name, offers, filters)
      if(filters[attribiute_name]) 
        filters[attribiute_name][1] = 50000 unless filters[attribiute_name][1]
        offers.filter {|offer| offer[attribiute_name] >= filters[attribiute_name][0].to_f && offer[attribiute_name] <= filters[attribiute_name][1].to_f}
      else
        offers
      end
    end

    def offer_and_user_contact(offer)
      return {
        user: {
          email: offer.provider.user.email,
          phone_number: offer.provider.phone_number,
          address: offer.provider.address
        },
        offer: {
          address: offer.address,
          addition_contact_data: offer.addition_contact_data
        }
      }
    end
end
