class MeasuresController < ApplicationController
  
  def index
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
