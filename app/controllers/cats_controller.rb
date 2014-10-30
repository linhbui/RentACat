class CatsController < ApplicationController
  before_action :require_current_user!, only: [:create, :edit, :update, :destroy]
  
  def index
    @cats = Cat.all
    render :index
  end
  
  def show
    @cat = Cat.find(params[:id])
    @requests = @cat.cat_rental_requests.order_by_start_date
    render :show    
  end
  
  def new
    @cat = Cat.new
    render :new    
  end
  
  def create
    @cat = Cat.new(cat_params)
    @cat.user_id = current_user.id
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end    
  end
  
  def edit
    @cat = current_user.cats.find_by_id(params[:id])
    @cat.nil? ? (render json: "You don't own the cat!") : (render :edit)
  end
  
  def update
    @cat = Cat.find(params[:id])
    
    if @cat.update(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end
  
  def destroy
    @cat = current_user.cats.find_by_id(params[:id])
    @cat.destroy unless @cat.nil? 
    redirect_to cats_url
  end
  
  private

  def cat_params
    params.require(:cat).permit(:sex, :name, :color, :birth_date, :description, :user_id)
  end
end
