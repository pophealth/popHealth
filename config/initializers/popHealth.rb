require 'hqmf-parser'

APP_CONFIG = YAML.load_file(Rails.root.join('config', 'popHealth.yml'))[Rails.env]

# insert races and ethnicities
(
  MONGO_DB['races'].drop() if MONGO_DB['races']
  MONGO_DB['ethnicities'].drop() if MONGO_DB['ethnicities']
  JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'code_sets', 'races.json'))).each do |document|
    MONGO_DB['races'].insert(document)
  end
  JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'code_sets', 'ethnicities.json'))).each do |document|
    MONGO_DB['ethnicities'].insert(document)
  end
) if MONGO_DB['races'].find.count == 0 || MONGO_DB['ethnicities'].find.count == 0

# insert languages
(
  JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'code_sets', 'languages.json'))).each do |document|
    MONGO_DB['languages'].insert(document)
  end
) if MONGO_DB['languages'].find({}).count == 0

