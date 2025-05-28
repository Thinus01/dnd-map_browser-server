# app/serializers/map_list_serializer.rb
class MapListSerializer < ActiveModel::Serializer
  attributes :id, :link
  has_many :tags, serializer: TagSerializer
end

# app/serializers/map_detail_serializer.rb
class MapDetailSerializer < ActiveModel::Serializer
  attributes :id, :link
  has_many :tags, serializer: TagSerializer
end
