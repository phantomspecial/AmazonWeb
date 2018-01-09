class SubCategoriesController < ApplicationController

  def index
    @sub_categories = SubCategory.all
  end

  def new
    @sub_category = SubCategory.new
  end

  def create
    @sub_category = SubCategory.new(new_sub_category_params)
    @sub_category.save
  end


  def find_sub_category
    @sub_category = SubCategory.find(params[:id])
  end

  private
  def new_sub_category_params
    params.require(:sub_category).permit(:category_id,:name)
  end
end
