class Report < ActiveRecord::Base
  #GEMS
  #ATTRIBUTES
  #ASSOCIATIONS
  #VALIDATIONS
  #CALLBACKS
  #FUNCTIONS
  class << self

    def user_report(user_id, group_by)
      user = User.find_by(user_id: user_id)

      where = "i.user_ids @> '{#{user_id}}'"
      group_by_str = get_group_string(group_by)
      unless group_by_str.present?
        return {success: false, error: "Invalid group selection."}
      end

      hashed_result = get_results(where, group_by_str)

      entity_records = case group_by
        when "projects"
          user.projects.select('"projects".project_id as entity_id', :name)
        when "partners"
          user.partners.select('"partners".partner_id as entity_id', :name)
        when "events"
          user.events.select('"events".event_id as entity_id', '"events".description as  name')
        when "publications"
          user.publications.select('"publications".publication_id as entity_id', '"publications".headline as name')
        else
          false
      end

      return {success: true, data: hashed_result, entity_records: entity_records}
    end


    def project_report(project_id, group_by)
      project = Project.find_by(project_id: project_id)

      where = "i.project_ids @> '{#{project_id}}'"
      group_by_str = get_group_string(group_by)
      unless group_by_str.present?
        return {success: false, error: "Invalid group selection."}
      end

      hashed_result = get_results(where, group_by_str)

      entity_records = case group_by
        when "partners"
          project.partners.select('"partners".partner_id as entity_id', :name)
        when "events"
          project.events.select('"events".event_id as entity_id', '"events".description as  name')
        else
          false
      end

      return {success: true, data: hashed_result, entity_records: entity_records}
    end

    private

      def get_results(where, group_by_str)
        query = Report.generic_query(where, group_by_str)
        result = Report.connection.exec_query(query)
        result = result.group_by(&:first).map { |k, v| [k, v.each(&:shift)] }.to_h
        hashed_result = {}
        result.each do |k, v|
          hashed_result[k.second] = {};
          value = v.each do |h|
            new_k = h["genre"] + "_" + h["metric_type"]
            hashed_result[k.second][new_k] = h["sum"]
          end
        end
        hashed_result
      end

      def generic_query(where, group_by_str)
        sql = <<-eoq
          SELECT unnest(#{group_by_str}), tm.genre, tm.metric_type, sum(tm.value)
            FROM items as i INNER JOIN trackable_metrics as tm
              ON i.impact_item_id = tm.item_id
            WHERE #{where}
              GROUP BY unnest(#{group_by_str}), tm.genre, tm.metric_type
            ORDER BY unnest(#{group_by_str}) ASC
        eoq
      end

      def get_group_string(group_by)
        case group_by
          when "projects"
            "i.project_ids"
          when "partners"
            "i.partner_ids"
          when "events"
            "i.event_ids"
          when "publications"
            "i.publication_id"
          else
            false
        end
      end
  end


end