class MeasuresController < ApplicationController
  
  def index
    @selected_measures = mongo['selected_measures'].find().to_a #need to call to_a so that it isn't a cursor
    @grouped_selected_measures = @selected_measures.group_by {|measure| measure['category']}
    @categories = Measure.all_by_category

    @patient_count = mongo['records'].count
    render 'dashboard'
  end
    
  def result
    executor = QME::MapReduce::Executor.new(mongo)
    @result = executor.measure_result(params[:id], params[:sub_id], :effective_date=>Time.gm(2010, 9, 19).to_i)
    
    render :json => @result
  end

  def definition
    executor = QME::MapReduce::Executor.new(mongo)
    @definition = executor.measure_def(params[:id], params[:sub_id])
    
    render :json => @definition
  end

  def show
    executor = QME::MapReduce::Executor.new(mongo)
    @definition = executor.measure_def(params[:id], params[:sub_id])
    
    render 'measure'
  end
  
  def select
    measure = Measure.add_measure(params[:id])
    render :partial => 'measure_stats', :locals => {:measure => measure}
  end
  
  def remove
    Measure.remove_measure(params[:id])
    render :text => 'Removed'
  end

end
