require 'swagger_helper'

describe 'Items API' do
  path '/items' do
    post 'Creates an item' do
      tags 'Items'
      consumes 'application/json'
      parameter name: :item_params, in: :body, schema: {
        type: :object,
        properties: {
          item_image: { type: :string, format: :binary }
        },
        required: ['item_image']
      }

      response '201', 'item created' do
        let(:item_params) { { item_image: 'base64_encoded_image_data' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:item_params) { { item_image: nil } }
        run_test!
      end
    end
  end

  path '/items/{id}' do
    get 'Retrieves an item' do
      tags 'Items'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'item found' do
        let(:id) { create(:item).id }
        run_test!
      end

      response '404', 'item not found' do
        let(:id) { 'invalid_id' }
        run_test!
      end
    end

    delete 'Deletes an item' do
      tags 'Items'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'item deleted' do
        let(:id) { create(:item).id }
        run_test!
      end

      response '404', 'item not found' do
        let(:id) { 'invalid_id' }
        run_test!
      end
    end
  end
end
