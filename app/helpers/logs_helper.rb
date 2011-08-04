module LogsHelper
  def time_range_params_plus(url_params_hash)
    url_params_hash[:log_start_date] = params[:log_start_date] if params[:log_start_date]
    url_params_hash[:log_end_date] = params[:log_end_date] if params[:log_end_date]
    url_params_hash
  end
end
