class CatRentalRequestsController < ApplicationController
  before_action :require_current_user!, except: [:new, :create]
  
  def new
    @cat_rental_request = CatRentalRequest.new
    @cats = Cat.all
  end
  
  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    @cats = Cat.all
    @cat_rental_request.user_id = current_user.id
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat)
    else
      flash.now[:errors] = @cat_rental_request.errors.full_messages
      render :new
    end
  end
  
  def destroy
    @cat_rental_request = CatRentalRequest.find(params[:id])
    user = @cat_rental_request.user
    if user == current_user 
      @cat_rental_request.destroy
      redirect_to cat_url(@cat_rental_request.cat)
    else
      render json: "Hey you cannot delete requests of others!!!"
    end
  end
   
   
  def approve
    @cat_rental_request = current_user.cats_requests.find_by_id(params[:cat_rental_request_id])
    if @cat_rental_request.nil?
      render json: "You are not the owner of this cat..."
    else
      @cat_rental_request.approve!
      redirect_to cat_url(@cat_rental_request.cat)
    end
  end
  
  def deny
    @cat_rental_request = current_user.cats_requests.find_by_id(params[:cat_rental_request_id])
    if @cat_rental_request.nil?
      render json: "You are not the owner of this cat..."
    else
      @cat_rental_request.deny!
      redirect_to cat_url(@cat_rental_request.cat)
    end
  end
  
  private
  
  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end