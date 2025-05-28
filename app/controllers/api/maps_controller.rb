# app/controllers/api/maps_controller.rb
module Api
  class MapsController < ApplicationController
    before_action :load_filters, only: [:index, :prev, :next]

    # GET /api/maps
    def index
      scoped = apply_filters(Map.all)
      total  = scoped.distinct.count(:id)

      maps = scoped
             .distinct
             .order(:id)
             .offset((@page - 1) * @per_page)
             .limit (@per_page)

      render json: {
        maps: ActiveModelSerializers::SerializableResource.new(maps, each_serializer: MapListSerializer),
        total_pages: (total.to_f / @per_page).ceil,
        current_page: @page
      }
    end

    # GET /api/maps/:id
    def show
      map = Map.find(params[:id])
      render json: map, serializer: MapDetailSerializer
    end

    # GET /api/maps/:id/prev
    def prev
      candidate = apply_filters(Map.all)
                  .where('maps.id < ?', params[:id].to_i)
                  .order(id: :desc)
                  .limit(1)
                  .pluck(:id)
                  .first
      render json: { id: candidate }
    end

    # GET /api/maps/:id/next
    def next
      candidate = apply_filters(Map.all)
                  .where('maps.id > ?', params[:id].to_i)
                  .order(:id)
                  .limit(1)
                  .pluck(:id)
                  .first
      render json: { id: candidate }
    end

    private

    # pull pagination/filter params
    def load_filters
      @page     = (params[:page]     || 1).to_i
      @per_page = (params[:per_page] || 20).to_i
      @tag_names = params[:tags].to_s.split(',').reject(&:blank?)
      @search_terms = params[:search].to_s.split(/\s+/).reject(&:blank?)
    end

    # apply both tag‐and search‐term filters to a Map::ActiveRecord_Relation
    def apply_filters(scope)
      # 1) exact-tag filter (clicking tags)
      if @tag_names.any?
        scope = scope
                .joins(:tags)
                .where(tags: { name: @tag_names })
                .group('maps.id')
                .having('COUNT(tags.id) = ?', @tag_names.size)
      end

      # 2) ILIKE‐search filter (space‐separated partial tag names)
      @search_terms.each_with_index do |term, idx|
        alias_mt = "mt_search#{idx}"
        alias_t  = "t_search#{idx}"
        scope = scope
                .joins("INNER JOIN maps_tags #{alias_mt} ON #{alias_mt}.map_id = maps.id")
                .joins("INNER JOIN tags #{alias_t} ON #{alias_t}.id = #{alias_mt}.tag_id AND #{alias_t}.name ILIKE :term#{idx}", **{"term#{idx}".to_sym => "%#{term}%"})
      end

      scope
    end
  end
end
