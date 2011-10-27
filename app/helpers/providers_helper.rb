module ProvidersHelper

  def checked(providers, provider)
    providers.detect { |pv| pv.id = provider.id } ? 'checked' : ''
  end
  
  
end
