class TagsController < ApplicationController
  # POST /tags
  def create
    tag = Tag.new(tag_params)
    if tag.save
      render json: tag, status: :created
    else
      render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def tag_params
    # expecting { tag: { name: "Forest" } }
    params.require(:tag).permit(:name)
  end
end
