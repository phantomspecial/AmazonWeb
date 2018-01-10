class ReviewsController < ApplicationController

  before_action :authenticate_user!

  def create
    @review = Review.create(stock_id: review_params[:stock_id], user_id: current_user.id, title: review_params[:title], rate: review_params[:rate], review: review_params[:review])

    @stock = Stock.find(review_params[:stock_id])
    @reviews = @stock.reviews

  end

  def edit
  end

  def update
    @stock = Stock.find(params[:stock_id])
    @review = Review.find(params[:id])
    if @review.user_id == current_user.id
      @review.update(review_params)
    end
    @reviews = @stock.reviews
  end

  def destroy
    @stock = Stock.find(params[:stock_id])
    review = Review.find(params[:id])
    if review.user_id == current_user.id
      review.destroy
    end
    @reviews = @stock.reviews
  end

  private
  def review_params
    params.permit(:stock_id, :title, :rate, :review)
    # params.require(:review).permit(:stock_id, :title, :rate, :review)
  end

end
