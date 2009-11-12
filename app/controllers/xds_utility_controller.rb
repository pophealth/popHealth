require_dependency 'sort_order'

class XdsUtilityController < ApplicationController
  
  page_title 'XDS Utility'
  
  include SortOrder
  self.valid_sort_fields = %w[ name created_at updated_at ]
   
  def index
      @patients = XdsRecordUtility.all_patients      
   
      
      unless sort_order.nil?
        sort_field = sort_order.split( ' ' ).first 
        sort_direction = sort_order.split( ' ' ).second 
      
        @patients.sort!{ |a,b|
          val_a = a.patient.try( sort_field.intern ) || ""
        
          val_b = b.patient.try( sort_field.intern ) || val_a.clone
       
          if ( val_a.class != val_b.class && val_a.class == String )
            -1
          else
            val_a <=> val_b
          end
        }
      
        if sort_direction == "DESC"
          @patients.reverse!
        end
      end
      
  end
  
end
