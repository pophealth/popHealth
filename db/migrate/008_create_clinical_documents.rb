class CreateClinicalDocuments < ActiveRecord::Migration
  def self.up
    create_table :clinical_documents do |t|
      t.integer :size
      t.string :content_type
      t.string :filename
      t.string :doc_type
      t.belongs_to :vendor_test_plan
    end
  end

  def self.down
    drop_table :clinical_documents
  end
end
