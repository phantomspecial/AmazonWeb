class ReviewsController < ApplicationController

  before_action :authenticate_user!

  def create
    @stock = Stock.find(review_params[:stock_id])
    if @review = Review.create(stock_id: review_params[:stock_id], user_id: current_user.id, title: review_params[:title], rate: review_params[:rate], review: review_params[:review])

      @reviews = @stock.reviews
      average_reviews(@stock)
    else
      redirect_to stock_path(@stock.id)
    end

  end

  def edit
  end

  def update
    @stock = Stock.find(params[:stock_id])
    @review = Review.find(params[:id])
    if @review.user_id == current_user.id
      @review.update(review_params)
      average_reviews(@stock)
    end
    @reviews = @stock.reviews
  end

  def destroy
    @stock = Stock.find(params[:stock_id])
    review = Review.find(params[:id])
    if review.user_id == current_user.id
      review.destroy
      average_reviews(@stock)
    end
    @reviews = @stock.reviews
  end

  private
  def review_params
    params.permit(:stock_id, :title, :rate, :review)
  end

  def average_reviews(stock)
    @reviews = stock.reviews
    if @reviews.present?
      avg = Review.where(stock_id: stock).average(:rate).round(1).to_f
      stock.update(avg_review: avg)
    else
      stock.update(avg_review: nil)
    end
  end

end
