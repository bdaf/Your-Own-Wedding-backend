class NamesController < ApplicationController
  include CurrentUserConcern
  before_action :authenticate_as_organizer
  before_action :set_addition_attribiute_name, only: %i[ show update destroy ]

  def index
    render json: @current_user.organizer.addition_attribiute_names, status: 200
  end
 
  def show
  end

  def create
    @addition_attribiute_name = @current_user.organizer.addition_attribiute_names.build(addition_attribiute_name_params)

    if @addition_attribiute_name.save
      render json: @addition_attribiute_name, status: :created, location: name_url(@addition_attribiute_name)
    else
      render json: @addition_attribiute_name.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
    @addition_attribiute_name.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_addition_attribiute_name
      @addition_attribiute_name = @current_user.organizer.addition_attribiute_names.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def addition_attribiute_name_params
      params.require(:addition_attribiute_name).permit(:name, :default_value)
    end
end


# class NamesController < ApplicationController
#   include CurrentUserConcern
#   before_action :authenticate_as_organizer
#   before_action :set_addition_attribiute_name, only: %i[update destroy ]
 
#   # GET /addition_attribiute_names_my
#   # GET /addition_attribiute_names_my.json
#   def index
#     debugger
#     render json: @current_user.organizer.addition_atribiute_names, status: 200
#   end

#   # POST /addition_attribiute_names
#   # POST /addition_attribiute_names.json
#   def create
#     debugger
#     @addition_attribiute_name = @currentUser.addition_attribiute_names.build(addition_attribiute_name_params)

#     if @addition_attribiute_name.save
#       render json: @addition_attribiute_name, status: :created, location: addition_attribiute_name_url(@addition_attribiute_name)
#     else
#       render json: @addition_attribiute_name.errors.full_messages, status: :unprocessable_entity
#     end
#   end

#   # PATCH/PUT /addition_attribiute_names/1
#   # PATCH/PUT /addition_attribiute_names/1.json
#   def update
#     debugger
#     if @addition_attribiute_name.update(addition_attribiute_name_params)
#       render json: @addition_attribiute_name, status: :ok, location: addition_attribiute_name_url(@addition_attribiute_name)
#     else
#       render json: @addition_attribiute_name.errors.full_messages, status: :unprocessable_entity
#     end
#   end

#   # DELETE /addition_attribiute_names/1
#   # DELETE /addition_attribiute_names/1.json
#   def delete 
#     debugger
#     @addition_attribiute_name.destroy!
#   end


#   private
#     # Use callbacks to share common setup or constraints between actions.
#     def set_addition_attribiute_name
#       @addition_attribiute_name = @current_user.organizer.addition_attribiutes_names.find(params[:id])
#     end

#     # Only allow a list of trusted parameters through.
#     def addition_attribiute_name_params
#       params.require(:addition_attribiute).permit(:name, :default_value)
#     end
# end
