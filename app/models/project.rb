# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null
#  project_id  :string           primary key
#  name        :string
#  user_ids    :text             default([]), is an Array
#  partner_ids :text             default([]), is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Project < ActiveRecord::Base

  #GEMS
  self.primary_key = "project_id"

  #ATTRIBUTES
  #ASSOCIATIONS

  def users
    User.where(user_id: self.user_ids)
  end

  def partners
    RefPartner.where(partner_id: self.partner_ids)
  end

  #VALIDATIONS
  #CALLBACKS
  #FUNCTIONS

  class << self
    def create_or_update(attrs)
      project = Project.where(project_id: attrs[:project_id]).first
      unless project.blank?
        # Update
        project = project.update_attributes(
          name: attrs[:name],
          user_ids: attrs[:user_ids],
          partner_ids: attrs[:partner_ids]
        )
      else
        # Create
        project = Project.create(attrs)
      end
      project
    end
  end
  #PRIVATE
end
