# == Schema Information
#
# Table name: ref_partners
#
#  id             :integer          not null
#  ref_partner_id :string           primary key
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class RefPartner < ActiveRecord::Base

  #GEMS
  self.primary_key = "ref_partner_id"

  #ATTRIBUTES
  #ASSOCIATIONS
  #VALIDATIONS
  #CALLBACKS
  #FUNCTIONS

  class << self
    def create_or_update(attrs)
      partner = RefPartner.where(ref_partner_id: attrs[:ref_partner_id]).first
      unless partner.blank?
        # Update
        partner = partner.update_attributes(
          name: attrs[:name]
        )
      else
        # Create
        partner = RefPartner.create(attrs)
      end
      partner
    end
  end

  #PRIVATE

end
