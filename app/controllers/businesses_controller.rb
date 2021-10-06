require 'http'

class BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :update, :destroy]

  # GET /businesses
  def index
    @businesses = Business.all

    render json: @businesses
  end

  # GET /businesses/1
  def show
    render json: @business
  end

  def new
  
    @business_ids = search_businesses(params[:term], params[:location])
    byebug   
    
    @business = Business.new

    unless @business
      flash[:alert] = "Business Not Found!"
      render :index
    end

    render json: @business_ids
  end


  # POST /businesses
  def create
    @business = Business.new(business_params)

    if @business.save
      render json: @business, status: :created, location: @business
    else
      render json: @business.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /businesses/1
  def update
    if @business.update(business_params)
      render json: @business
    else
      render json: @business.errors, status: :unprocessable_entity
    end
  end

  # DELETE /businesses/1
  def destroy
    @business.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    API_HOST = 'https://api.yelp.com';
    SEARCH_PATH = '/v3/businesses/search';
    BUSINESS_PATH = '/v3/businesses';
    SEARCH_LIMIT = 10;

    def set_business
      @business = Business.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def business_params
      params.require(:business).permit(:rating, :phone, :id, :name, :image_url, :location, :distance)
    end

    def search_businesses(term, location)
      
      url = URI("#{API_HOST}#{SEARCH_PATH}");

      params = {
        term: term,
        location: location,
        limit: SEARCH_LIMIT
      }

      response = HTTP.auth("Bearer #{ENV["YELP_API_KEY"]}").get(url, params: params)
  
      response.parse

    end
end
