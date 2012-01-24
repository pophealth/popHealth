module ProvidersHelper

  def checked(providers, provider)
    providers.detect { |pv| pv.id = provider.id } ? 'checked' : ''
  end
  
  def specialties
    Provider::Specialties.sort { |s1,s2| s1[1] <=> s2[1] }.map { |pair| pair.reverse }
  end
  
end
