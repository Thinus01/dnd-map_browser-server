# app/controllers/api/tags_controller.rb
module Api
  class TagsController < ApplicationController
    def index
      tags = Tag.order(:name)
      render json: tags, each_serializer: TagSerializer
    end
  end
end
