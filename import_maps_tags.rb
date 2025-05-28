# server/import_maps_tags.rb
# Usage: bin/rails runner import_maps_tags.rb

require 'json'

# ——— Define the join model (so Rails can load it) ———
class MapsTag < ApplicationRecord
  self.table_name = 'maps_tags'
end

# ——— Configuration ———
base_url   = "http://192.168.0.201:2503/"
# Adjust this path if your JSON lives elsewhere:
json_path  = Rails.root.join('..', 'image', 'maps_metadata.json')

# ——— Load metadata ———
entries = JSON.parse(File.read(json_path))

entries.each do |entry|
  filename  = entry['filename']
  safe_name = filename.gsub(' ', '%20')
  map_link  = base_url + safe_name

  map = Map.find_by(link: map_link)
  unless map
    warn "⚠️  No Map found for #{map_link}"
    next
  end

  entry['tags'].each do |tag_name|
    tag = Tag.find_by(name: tag_name)
    unless tag
      warn "⚠️  No Tag found named #{tag_name}"
      next
    end

    # Idempotent insert
    MapsTag.find_or_create_by!(map_id: map.id, tag_id: tag.id)
  end
end

puts "✅ Done linking #{MapsTag.count} map↔tag associations."
