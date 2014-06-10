require 'hqmf-parser'

APP_CONFIG = YAML.load_file(Rails.root.join('config', 'popHealth.yml'))[Rails.env]

# insert languages
(
  JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'code_sets', 'languages.json'))).each do |document|
    MONGO_DB['languages'].insert(document)
  end
) if MONGO_DB['languages'].find({}).count == 0
