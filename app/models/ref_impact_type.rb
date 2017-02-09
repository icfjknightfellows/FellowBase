# == Schema Information
#
# Table name: ref_impact_types
#
#  id                 :integer          not null
#  ref_impact_type_id :string           primary key
#  name               :text
#  genre              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class RefImpactType < ActiveRecord::Base

  #GEMS
  self.primary_key = "ref_impact_type_id"

  #ATTRIBUTES
  #ASSOCIATIONS
  #VALIDATIONS
  #CALLBACKS
  #FUNCTIONS

  class << self
    def create_or_update(attrs)
      impact_type = RefImpactType.where(ref_impact_type_id: attrs[:ref_impact_type_id]).first
      unless impact_type.blank?
        # Update
        impact_type = impact_type.update_attributes(
          name: attrs[:name],
          genre: attrs[:genre]
        )
      else
        # Create
        impact_type = RefImpactType.create(attrs)
      end
      impact_type
    end
  end

  #PRIVATE

end
