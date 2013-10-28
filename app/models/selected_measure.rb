class SelectedMeasure
  # include Mongoid::Document
  
  # field :username         , type: String
  # field :id               , type: String
  # field :name             , type: String
  # field :category         , type: String
  # field :description      , type: String
  # field :subs             , type: Array
  # field :short_subtitles  , type: Hash
  
  # Adds a measure to the selected_measure collection. It copies some of the measure information
  # from the measure collection
  # @param [String] measure_id the id of the measure to select
  # @param [String] username name of the user who this selected measure will belong
  # @return [Hash] representing the added measure. nil if the measure is already selected or if the
  #                measure id provided does not match any measures
  def self.add_measure(username, measure_id)

    if MONGO_DB['selected_measures'].find(:id => measure_id, :username => username).first
      return nil
    else
      measures = MONGO_DB['measures'].find(:id => measure_id)
      
      if measures
        selected_measure_doc = {'subs' => [], 'short_subtitles' => {}}
        measures.each do |measure|
          selected_measure_doc['username'] = username
          selected_measure_doc['id'] = measure['id']
          selected_measure_doc['name'] = measure['name']
          selected_measure_doc['category'] = measure['category']
          selected_measure_doc['description'] = measure['description']
          if measure['sub_id']
            selected_measure_doc['subs'] << measure['sub_id']
            selected_measure_doc['short_subtitles'][measure['sub_id']] = measure['short_subtitle']
          end
        end

        MONGO_DB['selected_measures'].insert(selected_measure_doc)

        return selected_measure_doc
      else
        return nil
      end
    end
  end
  
  def self.remove_measure(username, measure_id)
    MONGO_DB['selected_measures'].find(:id => measure_id, :username => username).remove()
  end
  
	# added by ssiddiqui
	def self.remove_all(username)
		while MONGO_DB['selected_measures'].find(:username => username).count() != 0 do		
			MONGO_DB['selected_measures'].find(:username => username).remove()
		end
	end

end
