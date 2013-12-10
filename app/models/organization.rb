class Organization
  # include Mongoid::Document
  # include Mongoid::Timestamps
  # #include Mongoid::Tree
  # # include Mongoid::Tree::Ordering
  # # include Mongoid::Tree::Traversal

  # field :name, type: String
  # field :type, type: String
  # field :npi,  type:  String
  # has_many :providers


  # def all_providers
  #   provs = self.descendants.collect do |d|
  #     d.providers
  #   end
  #   provs << self.providers
  #   provs.flatten!.uniq!
  # end

end
