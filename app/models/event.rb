# == Schema Information
#
# Table name: events
#
#  id              :integer          not null
#  event_id        :string           primary key
#  description     :text
#  project_ids     :text             default([]), is an Array
#  user_ids        :string           default([]), is an Array
#  partner_ids     :text             default([]), is an Array
#  impact_type_ids :text             default([]), is an Array
#  media           :text             default([]), is an Array
#  topics          :text             default([]), is an Array
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Event < ActiveRecord::Base

  #GEMS
  self.primary_key = "event_id"

  #ATTRIBUTES
  #ASSOCIATIONS

    def projects
      Project.where(project_id: self.project_ids)
    end

    def fetch_and_populate_partner_and_fellow
      projects = self.projects
      partners = projects.pluck(:partner_ids).flatten
      users = projects.pluck(:user_ids).flatten
      self.update_attributes({
        user_ids: users,
        partner_ids: partners,
      })
    end


  #VALIDATIONS
  #CALLBACKS
  #FUNCTIONS

  class << self
    def create_or_update(attrs)
      event = Event.where(event_id: attrs[:event_id]).first
      unless event.blank?
        # Update
        event.update_attributes(
          description: attrs[:description],
          project_ids: attrs[:project_ids],
          impact_type_ids: attrs[:impact_type_ids],
          media: attrs[:media],
          topics: attrs[:topics]
        )

        event = Event.where(event_id: attrs[:event_id]).first
        event.fetch_and_populate_partner_and_fellow
      else
        # Create
        event = Event.create(attrs)
        event.fetch_and_populate_partner_and_fellow
      end
      event
    end
  end
  #PRIVATE
end
