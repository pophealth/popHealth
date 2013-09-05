#This pulls the commit hash first-6 and most recent tag from git
g = Git.open(".")

PopHealth::Application.config.commit = g.log.first.objectish.slice(0,6)
PopHealth::Application.config.tag = g.tags.last.name