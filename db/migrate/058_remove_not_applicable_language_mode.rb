class RemoveNotApplicableLanguageMode < ActiveRecord::Migration
  
  def self.up
    # will attempt to find LanguageAbilityMode with name 'n/a' 
    # and destroy it.  
    # This would have been created from the migration specs
    begin 
      notApplicable = LanguageAbilityMode.find_by_name('n/a')
      notApplicable.destroy
    # don't do anything if this fails
    rescue
    end
  end

  def self.down
    notApplicable = LanguageAbililityMode.new(
      :name => 'n/a'  
    )
    notApplicable.save!
  end
end