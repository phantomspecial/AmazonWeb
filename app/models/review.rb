class Review < ApplicationRecord
  belongs_to :stock
  belongs_to :user


  def review_valid_test(r_params)
    if r_params[:stock_id].present? &&  r_params[:title].present? && r_params[:rate].present? && r_params[:review].present?
      return true
    else
      return false
    end
  end
end
