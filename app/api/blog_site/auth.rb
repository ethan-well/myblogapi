module BlogSite
  class Auth < Grape::API
    resource :auth do

      # example 'api/auth/login'
      desc 'auth user'
      params do
        requires :login, type: String, desc: 'user name or email'
        requires :password, type: String, desc: 'password'
      end
      post :login do
        user = if params[:login].include?('@')
                 User.find_by_email(params[:login])
               else
                 User.find_by_name(params[:login])
               end
        if user && user.authenticate(params[:password])
          api_key = user.generate_or_update_api_key
          {status: 1, msg: 'authorized', access_token: api_key.access_token, expires_at: api_key.expires_at}
        else
          {status: 0, msg: 'Unauthorized'}
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
          {status: 1, msg: 'welcome here!', access_token: api_key.access_token}
        rescue => ex
          {status: 0, msg: "sign up failed, message: #{ex.message}"}
        end
      end

      # example 'api/auth/logout'
      desc 'user logout'
      params do
        requires :access_token, type: String, desc: 'access token'
      end
      delete :logout do
        begin
          ApiKey.find_by_access_token(params[:access_token]).destroy!
          {status: 1, msg: "sign out success"}
        rescue => ex
          {status: 0, msg: "sign out failed, message: #{ex.message}"}
        end
      end
    end
  end
end
