module HealthDataStandards
  module CQM
    class QueryCache

      # FIXME:
      def self.aggregate_measure(measure_id, effective_date, effective_start_date, filters=nil, test_id=nil)
        query_hash = {'effective_date' => effective_date, 'effective_start_date' => effective_start_date, 'measure_id' => measure_id,
                      'test_id' => test_id}
        if filters
          query_hash.merge!(filters)
        end
        cache_entries = self.where(query_hash)
        aggregate_count = AggregateCount.new(measure_id)
        cache_entries.each do |cache_entry|
          aggregate_count.add_entry(cache_entry)
        end
        aggregate_count
      end
    end
  end
end
