module Commentable

  def self.included(base)
    base.class_eval do
      has_one :comment, :as => :commentable, :dependent => :destroy
      #accepts_nested_attributes_for :comment, :allow_destroy => true,
      #  :reject_if => proc { |attrs| attrs['text'].blank? }
      include CommentableInstance
    end
  end

  module CommentableInstance
    def clone
      copy = super
      copy.save!
      copy.comment = comment.clone if comment
      copy
    end

    def comment_blank?
      comment.text.blank? 
    end
  end

end
