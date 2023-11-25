class ItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update, :destroy]
  before_action :set_item, only: %i[show]
  def create
    @item = Item.create(item_params)
    @item.save
    render json: @item
  end

  def show
    if @item.nil?
      render json: {error: "İtem not found!"}, status: :bad_request
      return
    end
    image = rails_blob_url(@item.item_image.variant(resize_to_limit: [500, 500]))
    render json: {"image": image}
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.permit(:item_image)
  end
end
