# server/import_tags.rb
# Usage: bin/rails runner import_tags.rb

# 1. Define your array of names
tag_names = [
  "1x1","1x2","1x3","1x4","2x3","3x2","4x1",
  "Forest","Dark Forest","Winter Forest","Jungle","Swamp","Tundra","Desert",
  "Snow","Mountain","Grasslands","Beach","Cave","River","Lava","Volcano",
  "Ocean","Underwater","Floating Island","Island","Castle","Fortress","Palace",
  "Temple","Dungeon","Crypt","Mine","Village","Town","City","Church","Tavern",
  "Marketplace","Blacksmith","Train Station","Library","Prison","Bridge","Mill",
  "Ruins","Road","Tunnel","Labyrinth","Ancient","Greek Temple","Roman Forum",
  "Aztec Temple","Viking","Cyberpunk","Sci-Fi","Post-Apocalypse","Fantasy",
  "Realistic","Haunted","Enchanted","Arcane","Dimensional","Astral","Shadowfell",
  "Feywild","Alien World","Battleground","Base","Outpost","Checkpoint","Ambush Site",
  "Exploration","Roleplay","Combat Zone","Story Event","Night","Day","Indoor","Outdoor"
]

# 2. Sort them
tag_names.sort!

# 3. Upsert into tags table
tag_names.each do |name|
  Tag.find_or_create_by!(name: name)
end

puts "Ensured #{Tag.count} tags in the database."
