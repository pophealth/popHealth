module ProvidersHelper

  def checked(providers, provider)
    providers.detect { |pv| pv.id = provider.id } ? 'checked' : ''
  end
  
  def specialties
    Provider::Specialties.sort { |s1,s2| s1[1] <=> s2[1] }.map { |pair| pair.reverse }
  end
  
  def formatted_provider_name(provider)
    return "" if provider.blank?
    return "#{provider.id}, Provider" if provider.family_name.blank? or provider.given_name.blank?
    "#{provider.family_name.upcase}, #{provider.given_name}"
  end
end
