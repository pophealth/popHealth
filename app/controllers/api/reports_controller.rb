module Api
  
  class ReportsController < ApplicationController
    before_filter :authenticate_user!
skip_authorization_check
    def cat3
      measure_ids = params[:measure_ids] ||current_user.preferences["selected_measure_ids"]
      filter = measure_ids=="all" ? {}  : {:hqmf_id.in =>measure_ids}
      exporter =  HealthDataStandards::Export::Cat3.new
      effective_date = params["effective_date"] || current_user.effective_date
      end_date = Time.at(effective_date.to_i)
      render text: exporter.export(HealthDataStandards::CQM::Measure.top_level.where(filter), 
                                   generate_header, 
                                   effective_date, 
                                   end_date.years_ago(1), 
                                   end_date)
    end

    private
  #This is real ugly and needs to be thought out as to how we generate header information for Cat 3 documents
    def generate_header
     header_hash=  {identifier: {root: "header_root", extension: "header_ext"},
       authors: [{ids: [ {root: "author_root" , extension: "author_extension"}],
                     device: {name:"dvice_name" , model: "device_mod"},
                     addresses:[],
                     telecoms: [],
                     time: Time.now,
                     organization: {ids: [ {root: "authors_organization_root" , extension: "authors_organization_ext"}],
                                    name: ""}}],
       custodian: {ids: [ {root: "custodian_root" , extension: "custodian_ext"}],
                   person: {given: "", family: ""},
                   organization: {ids: [ {root: "custodian_rganization_root" , extension: "custodian_organization_ext"}],
                                  name: ""}},
       legal_authenticator:{ids: [ {root: "legal_authenticator_root" , extension: "legal_authenticator_ext"}],
                            addresses: [],
                            telecoms:[],
                            time: Time.now,
                            person: {given:"hey", family: "there"},
                            organization:{ids: [ {root: "legal_authenticator_org_root" , extension: "legal_authenticator_org_ext"}],
                                          name: ""}
                            }
        }
      
      Qrda::Header.new(header_hash)
    end
  end
end
