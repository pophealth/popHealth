[
  ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS,
  ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS
].each do |df|
  df[:default]         = '%B %d, %Y'
  df[:brief]           = '%Y%m%d'
  df[:year]            = '%Y'
  df[:brief_timestamp] = '%Y%m%d%H%M%S'
  df[:long_timestamp]  = '%d.%b.%Y %I:%M %p %Z'
end

