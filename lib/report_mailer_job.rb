class ReportMailerJob
#  attr_accessor :file, :current_user, :practice, :filename
  
  def initialize(options)
    @current_user = options['user']
    @practice = options['practice']
    @filename = options['filename']
  end

  def before
  end

  def perform
  end

  def after
  end
end
