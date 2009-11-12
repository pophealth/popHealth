module XDSUtils
  class RetrieveFailed < StandardError; end
  
  

  def self.retrieve_document(metadata)
    req = XDS::RetrieveDocumentSetRequest.new(Setting.xds_retrieve_document_set_request_url)
    req.add_ids_to_request(metadata.repository_unique_id,metadata.unique_id)
    docs = req.execute
    if docs
      file_data = {"content_type"=>metadata.mime_type,
                   "size"=>metadata.size,
                   "filename"=>"registry_file",
                   "tempfile"=>StringIO.new(docs[0][:content])}
      return file_data
    else
      raise RetrieveFailed,
        "failed with repository unique ID: #{metadata.repository_unique_id}, unique ID: #{metadata.unique_id}"
    end
  end

  def self.list_document_metadata(patient_identifier)
    XDS::RegistryStoredQueryRequest.new(Setting.xds_register_stored_query_url, {
      "$XDSDocumentEntryPatientId" => "'#{patient_identifier}'",
      "$XDSDocumentEntryStatus" => "('urn:oasis:names:tc:ebxml-regrep:StatusType:Approved')"
    }).execute
  end

  def self.provide_and_register(metadata, document)
    XDS::ProvideAndRegisterDocumentSetBXop.new(
      Setting.xds_retrieve_document_set_request_url, metadata, document
    ).execute
  end
end
