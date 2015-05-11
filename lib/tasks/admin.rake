require ::File.expand_path('../../../config/environment',  __FILE__)

namespace :admin do
  task :create_admin_account do
    admin_account = User.new(
                     :first_name =>     "Administrator",
                     :last_name =>      "Administrator",
                     :username =>       "pophealth",
                     :password =>       "pophealth",
                     :email =>          "provideadmin@providemycompanyname.com",
                     :approved =>       true,
                     :admin =>          true,
                     :agree_license =>  true)
    admin_account.save!
    
    if ! APP_CONFIG['use_opml_structure']
      # create root provider
      identifier = CDAIdentifier.new({root: "Organization", extension: "Administrator"})
      provider = Provider.create(:given_name => "Administrator")
      provider.cda_identifiers << identifier
      provider.save!
      
      admin_account.provider_id = provider.id
      admin_account.save!
    end
  end
end
