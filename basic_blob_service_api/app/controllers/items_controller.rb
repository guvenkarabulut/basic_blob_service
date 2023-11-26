class ItemsController < ApplicationController
  include ItemsHelper

  before_action :set_item, only: %i[show destroy]
  after_action :clean_empty_folders_action, only: :destroy
  before_action :set_image_variant, only: %i[show index]

  def create
    @item  = Item.create(item_params)
    if @item.save
      render json: @item
    else
      render json: { error: 'Failed to create item' }, status: :unprocessable_entity
    end
  end

  def show
    render_not_found unless @item
    @image = rails_blob_url(@item.item_image.variant(@image_variant))
    render json: { image: @image, item: @item }
  end

  def index
    @items = User.find(params[:user_id]).items
    @item_hashes = []
    @items.each do |i|
      @item_hashes << {
        image: rails_blob_url(i.item_image.variant(@image_variant)),
        item: i
      }
    end
    render json: @item_hashes
  end


  def destroy
    if @item
      @photo = @item.item_image
      @photo.purge_later
      @item.destroy
      render json: { message: 'Destroy is successful' }, status: :ok
    else
      render_not_found
    end
  end



  private
  def clean_empty_folders_action
    clean_empty_folders(Rails.root.join('storage'))
    clean_empty_folders(Rails.root.join('storage'))
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.permit(:item_image, :user_id)
  end
  def set_image_variant
    @image_variant = case params[:v]
                     when 'thumb' then :thumb
                     when 'cover' then :cover
                     else
                       :default_variant
                     end
  end

  def render_not_found
    render json: { error: 'Item not found!' }, status: :bad_request
  end
end