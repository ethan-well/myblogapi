module BlogSite
  class Auth < Grape::API

    helpers do
      def authenticate!
        error!('Unauthorized. Invalid or expired token.', 401) unless current_user
      end

      def current_user
        # find token. Check if valid.
        token = ApiKey.where(access_token: params[:token]).first
        if token && !token.expired?
          @current_user = User.find(token.user_id)
        else
          false
        end
      end
    end

    resource :auth do

      # example 'api/auth/login'
      desc 'auth user'
      params do
        requires :login, type: String, desc: 'user name or email'
        requires :password, type: String, desc: 'password'
      end
      post :login do
        if params[:login].include?('@')
          user = User.find_by_email(params[:login])
        else
          user = User.find_by_name(params[:login])
        end

        if user && user.authenticate(params[:password])
          api_key = ApiKey.create(user_id: user.id)
          {token: api_key.access_token}
        else
          error!('Unauthorized.', 401)
        end
      end

      # example 'api/auth/join'
      desc 'user sigup'
      params do
        requires :name, type: String, desc: 'user name'
        requires :email, type: String, desc: 'user email'
        requires :password, type: String, desc: 'user password'
        requires :password_confirmation, type: String, desc: 'user password confirmation'
      end
      post :join do
        user = User.find_by_email(params[:email])
        return {status: 0, msg: 'email exist'} if user.present?
        return {status: 0, msg: 'password_confirmation is not match the password'} if params[:password] != params[:password_confirmation]
        begin
          user = User.create!(name: params[:name], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
          api_key = ApiKey.create!(user_id: user.id)
          {status: 1, msg: 'welcome here!', token: api_key.access_token}
        rescue => ex
          {status: 0, msg: "sign up failed, message: #{ex.message}"}
        end
      end
    end
  end
end
