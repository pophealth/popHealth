module XdsRecordUtility 

  class XDSRecord
    attr_accessor :patient, :documents, :id, :id_scheme, :value

    def eql? other
      %w[ value id documents id_scheme patient ].all? do |f|
        send(f) == other.send(f)
      end
    end
    alias == eql?
  end
  
  #instantiate all identifiers in the registry as XDSRecords
  def self.all_patients
    
    patients = []
    
    all_identifiers.each do |identifier|
     
      xds_record = XDSRecord.new
      xds_record.documents = documents(  identifier[ 'identificationscheme' ], identifier['value'] )
      xds_record.value = identifier['value']
      xds_record.id = identifier['id']
      xds_record.id_scheme = identifier[ 'identificationscheme' ]
      xds_record.patient = Patient.find_by_patient_identifier( identifier[ 'value' ] )
      
      patients << xds_record
    end
    
    patients
    
  end
  
  
  #get all identifiers in the registry
  def self.all_identifiers
     
     establish_connection
          
      xds_all_ids_query = "SELECT patId.value, patId.identificationScheme, patId.id FROM ExternalIdentifier patId"
      begin
        ActiveRecord::Base.connection_handler.retrieve_connection( self ).select_all( "#{xds_all_ids_query}\n" )
      rescue ActiveRecord::StatementInvalid
         return
      end
  end
  
  #get documents/object ids associated with an identifier in the registry
  def self.documents( id_scheme, value )
  
    establish_connection
    
    xds_docs_query = "SELECT doc.id
                FROM ExtrinsicObject doc, ExternalIdentifier patId
                WHERE
                  doc.id = patId.registryobject AND      
                  patId.identificationScheme='#{id_scheme}'
                AND
                  patId.value = '#{value}';" 
    begin
      ActiveRecord::Base.connection_handler.retrieve_connection( self ).select_values( "#{xds_docs_query}\n" )
    rescue ActiveRecord::StatementInvalid
      return
    end  
  end
  
  private
  
  #connect to XDS registry via ActiveRecord
  def self.establish_connection
    
    #check to see if we've already opened a connection...have to do this manually
    #as connected? only checks classes that inherit from ActiveRecord::Base
     if ActiveRecord::Base.connection_handler.connection_pools[ self.name ].nil?
       
     
      spec = ActiveRecord::Base.configurations['nist_xds_registry'] #get the nist configuration
      
      #borrowed from ActiveRecord::Base.establish_connection
      spec = spec.symbolize_keys
      unless spec.key?(:adapter) then raise ActiveRecord::AdapterNotSpecified, "database configuration does not specify adapter" end
      
  
      begin
        require 'rubygems'
        gem "activerecord-#{spec[:adapter]}-adapter"
        require "active_record/connection_adapters/#{spec[:adapter]}_adapter"
      rescue ActiveRecord::LoadError
          begin
            require "active_record/connection_adapters/#{spec[:adapter]}_adapter"
          rescue ActiveRecord::LoadError
            raise "Please install the #{spec[:adapter]} adapter: `gem install activerecord-#{spec[:adapter]}-adapter` (#{$!})"
          end
      end
      
      adapter_method = "#{spec[:adapter]}_connection"
     
     #make ourselves a new connection specification
      connection_spec = ActiveRecord::Base::ConnectionSpecification.new( spec, adapter_method )
      
      #clear any existing connections with this class
      ActiveRecord::Base.connection_handler.remove_connection( self )
      
      #establish a new connection only associated with this class
      ActiveRecord::Base.connection_handler.establish_connection( self.name, connection_spec )
    end
    
  end
  
end
