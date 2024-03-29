# frozen_string_literal: true

module Users
  # class Sessions controller
  class SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token, raise: false
    before_action :pagination
    def pagination
      @users = User.page(params[:page])
    end

    def show
      @user = User.find(params[:id])
      render json: @user
    end

    def index
      @users = User.all
      render json: @users
    end

    def respond_with(current_user, _opts = {})
      render json: {
        code: 200,
        message: 'Logged in successfully.',
        data: current_user
      }, status: :ok
    end

    def respond_to_on_destroy
      if request.headers['Authorization'].present?
        jwt_payload = decode_jwt
        current_user = User.find(jwt_payload['sub'])
      end
      if current_user
        return_success_response
      else
        return_failed_response
      end
    end

    private

    def return_success_response
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    end

    def return_failed_response
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end

    def decode_jwt
      JWT.decode(
        request.headers['Authorization'].split(' ').last,
        Rails.application.credentials.fetch(:secret_key_base)
      ).first
    end
  end
end
