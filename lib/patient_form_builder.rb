class PatientFormBuilder < ActionView::Helpers::FormBuilder
  # Render nested form fields for person_name.
  def person_name_fields
    @template.render 'person_names/edit', :parent => self, :person_name => object.person_name
  end
  
  # Render nested form fields for telecom.
  def telecom_fields
    @template.render 'telecoms/edit', :parent => self, :telecom => object.telecom
  end
  
  # Render nested form fields for address.
  def address_fields
    @template.render 'addresses/edit', :parent => self, :address => object.address
  end
end

