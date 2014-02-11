begin
  #This pulls the commit hash first-6 and most recent tag from git
  g = Git.open(".")

  PopHealth::Application.config.commit = g.log.first.objectish.slice(0,6)
  last_tag = g.tags.last
  PopHealth::Application.config.tag = last_tag ? last_tag.name : "Unknown"
rescue ArgumentError => e
  #Path does not exist
  PopHealth::Application.config.commit = "Unknown"
  PopHealth::Application.config.tag = "Unknown"
end