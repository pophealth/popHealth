class AddCommentableFields < ActiveRecord::Migration

  def self.up
    add_column "comments", "commentable_id", :integer
    add_column "comments", "commentable_type", :string
  end

  def self.down
    remove_column "comments", "commentable_id"
    remove_column "comments", "commentable_type"
  end

end
