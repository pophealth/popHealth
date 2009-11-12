module Laika
  module Extensions
    module String
      # Converts an HL7 Timestamp in a String into a Date
      def from_hl7_ts_to_date
        Date.strptime(self, '%Y%m%d')
      end
    end
  end
end

class String
  include Laika::Extensions::String
end