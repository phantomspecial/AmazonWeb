class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(new_category_params)
    @category.save
    redirect_to categories_path
  end

  def edit
    find_category
  end

  def update
    find_category
    @category.update(new_category_params)
    redirect_to categories_path
  end

  def find_category
    @category = Category.find(params[:id])
  end

  private
  def new_category_params
    params.require(:category).permit(:name,:description)

  end

end
