require 'v8'

class MeasuresController < ApplicationController
  
  def index
    @measures = Measure.all
  end
    
  def result
    executor = QME::MapReduce::Executor.new(MONGO_CONNECTION.db('test'))
    @result = executor.measure_result(params[:id], :effective_date=>Time.gm(2010, 9, 19).to_i)
    
    render :json => @result
  end

  def definition
    executor = QME::MapReduce::Executor.new(MONGO_CONNECTION.db('test'))
    @definition = executor.measure_def(params[:id])
    
    render :json => @definition
  end

end
