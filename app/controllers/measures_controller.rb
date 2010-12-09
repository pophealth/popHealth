class MeasuresController < ApplicationController
  
  def index
    @measures = mongo['measures'].group([:id, :name], nil,
                                        {:subs => []},
                                        "function(obj,prev) {if (obj.sub_id != null) {prev.subs.push(obj.sub_id);}}")
    render 'dashboard'
  end
    
  def result
    executor = QME::MapReduce::Executor.new(mongo)
    @result = executor.measure_result(params[:id], nil, :effective_date=>Time.gm(2010, 9, 19).to_i)
    
    render :json => @result
  end

  def definition
    executor = QME::MapReduce::Executor.new(mongo)
    @definition = executor.measure_def(params[:id], nil)
    
    render :json => @definition
  end

  def show
    executor = QME::MapReduce::Executor.new(mongo)
    @definition = executor.measure_def(params[:id], nil)
    
    render 'measure'
  end

end
