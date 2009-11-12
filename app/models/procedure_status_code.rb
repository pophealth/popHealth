class ProcedureStatusCode < ActiveRecord::Base
  extend RandomFinder
    has_select_options :label_column => :description,
                      :order => "description ASC"
    
end
