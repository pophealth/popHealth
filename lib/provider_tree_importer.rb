require 'rexml/document'

class ProviderTreeImporter
  class ProviderEntry
    attr_accessor :attributes, :sub_providers

    def initialize(element)
      @attributes = map_attributes_to_hash(element.attributes)
      @sub_providers = element.elements.map { |this| ProviderEntry.new(this) }
    end

    def flatten
      @flatten ||= @sub_providers.map(&:flatten).unshift(self)
    end

    def to_s
      @to_s ||= attributes['text'] || super
    end

    def respond_to?(method)
      return true if attributes[method.to_s]
      super
    end

    private

    def map_attributes_to_hash(attributes)
      list = {}
      attributes.each { |key, value| list[key.underscore] = value }
    end
  end

  attr_reader :sub_providers

  def initialize(xml)
    @doc = REXML::Document.new(xml)
    @sub_providers = document_body ? initialize_subproviders_from_document_body : []
  end

  def flatten
    @flatten ||= @sub_providers.map(&:flatten).flatten
  end

  def load_providers(provider_list, parent=nil)
      provider_list.each do |sub|
      prov = Provider.new(
        :given_name   => sub.attributes["name"],
        :address        => sub.attributes["address"],
        )
      possible_npi = sub.attributes["id"]
      if possible_npi.present?
        prov.npi = possible_npi
      end
      sub.attributes.each_pair do |root, extension|
        unless ['tin', 'id', 'name', 'address', 'npi'].include? root
          prov.cda_identifiers << CDAIdentifier.new(root: root, extension: extension)
        end
      end

      if parent
        parent.children << prov
      end
      prov.save
      load_providers(sub.sub_providers, prov)
    end
  end 

  private

  def document_body
    @document_body ||= @doc.elements['opml/body']
  end

  def initialize_subproviders_from_document_body
    document_body.elements.map { |element| ProviderEntry.new(element) }
  end
    
end