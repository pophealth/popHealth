require 'attachment_fu_fixtures'

# i can haz fixturs too!
ActiveRecord::ConnectionAdapters::AbstractAdapter.module_eval do
  include Mynyml::AttachmentFuFixtures
  alias_method_chain :insert_fixture, :attachment
end
