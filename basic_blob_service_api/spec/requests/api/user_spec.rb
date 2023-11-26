require 'swagger_helper'

describe 'User Controller' do
  describe 'User API' do
    path '/users' do
      post 'Creates a user' do
        tags 'Users'
        consumes 'application/json'
        parameter name: :user_params, in: :body, schema: {
          type: :object,
          properties: {
            username: { type: :string },
            password: { type: :string },
            age: { type: :integer }
          },
          required: ['username', 'password']
        }

        response '201', 'user created' do
          let(:user_params) { { username: 'test_user', password: 'password123', age: 25 } }
          run_test!
        end

        response '422', 'invalid request' do
          let(:user_params) { { username: 'test_user', password: '', age: 25 } }
          run_test!
        end
      end

      post 'Logs in a user' do
        tags 'Users'
        consumes 'application/json'
        parameter name: :login_params, in: :body, schema: {
          type: :object,
          properties: {
            username: { type: :string },
            password: { type: :string }
          },
          required: ['username', 'password']
        }

        response '200', 'user logged in' do
          let(:login_params) { { username: 'existing_user', password: 'password123' } }
          run_test!
        end

        response '422', 'invalid credentials' do
          let(:login_params) { { username: 'nonexistent_user', password: 'wrong_password' } }
          run_test!
        end
      end
    end

    path '/auto_login' do
      get 'Auto login' do
        tags 'Users'
        security [Bearer: []]

        response '200', 'returns the logged-in user' do
          let(:Authorization) { "Bearer #{token_for_logged_in_user}" }
          run_test!
        end

        response '401', 'unauthorized' do
          run_test!
        end
      end
    end
  end
end
