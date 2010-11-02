require 'mongo'
require 'v8'

class MeasuresController < ApplicationController
  
  def index
    @measures = Measure.all
  end
    
  def result
    @db = Mongo::Connection.new('localhost', 27017).db('test')
    executor = QME::MapReduce::Executor.new(@db)
    @result = executor.measure_result(params[:id], :effective_date=>Time.gm(2010, 9, 19).to_i)
    
    render :json => @result
  end

  def definition
    @db = Mongo::Connection.new('localhost', 27017).db('test')
    executor = QME::MapReduce::Executor.new(@db)
    @definition = executor.measure_def(params[:id])
    
    render :json => @definition
  end

end
