class SubCategoriesController < ApplicationController

  def index
    category = Category.find(params[:category_id])
    render json: category.sub_categories.select(:id, :name)
  end

  def new
    @sub_category = SubCategory.new
    @sub_category.stocks.build
  end

  def create
    @sub_category = SubCategory.new(new_sub_category_params)
    @sub_category.save
  end

  def show
    find_sub_category
    @category = Category.find(params[:category_id])
    @all_categories = Category.all
    @sub_category = SubCategory.find(params[:id])
  end


  def find_sub_category
    @sub_categories = SubCategory.where(category_id: params[:category_id])
  end

  private
  def new_sub_category_params
    params.require(:sub_category).permit(:category_id,:name, :stocks_attributes [:id,:name,:image])
  end
end
