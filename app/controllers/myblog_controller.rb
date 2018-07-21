class MyblogController < ApplicationController
  protect_from_forgery except: :test

  def index
  end
  
  def test
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
    respond_to do |format|
      format.json do
        render json: {test2: 'test2'}, :callback => params[:callback]        
      end
      format.js do
        render json: {test2: 'test2'}, :callback => params[:callback]
      end
    end
  end

  def options
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Content-Type'
    headers['Access-Control-Max-Age'] = '1000'
    head :ok
  end

  def test_post
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",") 
    respond_to do |format|
      format.json do
        render json: params.to_json
      end
      format.js do
        render json: params.to_json
      end
    end
  end

end