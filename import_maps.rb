# import_maps.rb
# Usage: bin/rails runner import_maps.rb

image_dir = Rails.root.join("..", "image")
base_url  = "http://192.168.0.201:2503/"

Dir
  .glob("#{image_dir}/*.{jpg,jpeg,png,gif}")
  .each do |full_path|
    filename = File.basename(full_path)
    # encode spaces as %20, leave comma intact
    safe_name = filename.gsub(" ", "%20")
    url       = base_url + safe_name

    Map.create!(
      link:       url,
      favourites: false
    )
  end

puts "Imported #{Map.count} maps."
