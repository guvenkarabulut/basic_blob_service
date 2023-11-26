class ItemsController < ApplicationController
  include ItemsHelper

  before_action :set_item, only: %i[show destroy]
  after_action :clean_empty_folders_action, only: :destroy

  def create
    @item = Item.create(item_params)
    if @item.save
      render json: @item
    else
      render json: { error: 'Failed to create item' }, status: :unprocessable_entity
    end
  end

  def show
    render_not_found unless @item

    image_variant = case params[:v]
                    when 'thumb' then :thumb
                    when 'cover' then :cover
                    else
                      :default_variant
                    end

    @image = rails_blob_url(@item.item_image.variant(image_variant))
    render json: { image: @image, item: @item }
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
    @item = Item.find_by(id: params[:id])
  end

  def item_params
    params.permit(:item_image)
  end

  def render_not_found
    render json: { error: 'Item not found!' }, status: :bad_request
  end
end