class CategoriesController < ApplicationController

  def index
    @categories = Category.all
    @sub_categories = Sub_category.all
  end

  def new
    @category = Category.new
    @category.sub_categories.build
  end

  def create
    @category = Category.new(new_category_params)
    @category.save
    redirect_to admin_category_categories_path
  end

  def edit
    find_category
  end

  def update
    find_category
    @category.update(new_category_params)
    redirect_to admin_category_categories_path
  end

  def find_category
    @category = Category.find(params[:id])
  end

  def admin_category
    @categories = Category.all
  end

  private
  def new_category_params
    params.require(:category).permit(:name,:description, sub_categories_attributes: [:name])
  end

end
