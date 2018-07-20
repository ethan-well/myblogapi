class MyblogController < ApplicationController
  protect_from_forgery except: :test
  def index
  end
  
  def test
    respond_to do |format|
      format.js do
        render json: {test2: 'test2'}, :callback => params[:callback]
      end
    end
  end
end