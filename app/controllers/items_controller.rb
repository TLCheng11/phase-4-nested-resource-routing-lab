class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    if params[:user_id]
      items = User.find(params[:user_id]).items
      render json: items
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    if params[:user_id]
      items = User.find(params[:user_id]).items.find(params[:id])
      render json: items
    else
      item = Item.find(params[:id])
      render json: item
    end
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = Item.create(item_params)
      user.items << item
      render json: item, status: 201
    else
      item = Item.create(item_params)
      render json: item
    end
  end

  private

  def not_found(error)
    render json: {error: error.message}, status: 404
  end

  def item_params
    params.permit(:name, :description, :price)
  end

end
