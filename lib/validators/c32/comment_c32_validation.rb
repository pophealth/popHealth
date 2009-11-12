
module CommentC32Validation


  include MatchHelper

  #Reimplementing from MatchHelper
  def section_name
    self.commentable_type.underscore
  end

  #Reimplementing from MatchHelper  
  def subsection_name
    'comment'
  end

  def validate_c32(name_element)

  end

end