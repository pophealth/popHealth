module BSON
  class ObjectId
    def as_json(options = {})
      to_s
    end
  end
end