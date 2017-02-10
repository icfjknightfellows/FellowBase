class AddMaterializedView < ActiveRecord::Migration[5.0]

  def up
    execute "CREATE MATERIALIZED VIEW digital_asset_report AS
      SELECT
        e.event_id,
        e.description AS event_name,
        e.impact_type_id,
        e.media,
        e.topic,
        e.user_id,
        u.name AS fellow,
        it.name AS impact_type,
        it.genre AS impact_type_genre,
        rp.ref_partner_id,
        rp.name AS partner_name,
        p.project_id,
        p.name AS project_name,
        da.digital_asset_id,
        da.asset,
        tm.genre,
        tm.metric_type,
        tm.value
      FROM (
        SELECT
          e.event_id,
          e.description,
          CASE WHEN e.project_ids <> '{}' THEN unnest(e.project_ids) END AS project_id,
          CASE WHEN e.user_ids <> '{}' THEN unnest(e.user_ids) END AS user_id,
          CASE WHEN e.partner_ids <> '{}' THEN unnest(e.partner_ids) END AS partner_id,
          CASE WHEN e.impact_type_ids <> '{}' THEN unnest(e.impact_type_ids) END AS impact_type_id,
          CASE WHEN e.media <> '{}' THEN unnest(e.media) END AS media,
          CASE WHEN e.topics <> '{}' THEN unnest(e.topics) END AS topic
        FROM events AS e
      ) e INNER JOIN digital_assets AS da
          ON e.event_id = da.event_id
      INNER JOIN ref_impact_types AS it
        ON e.impact_type_id = it.ref_impact_type_id
      RIGHT JOIN projects AS p
        ON e.project_id = p.project_id
      RIGHT JOIN ref_partners AS rp
        ON e.partner_id = rp.ref_partner_id
      RIGHT JOIN users as u
        ON e.user_id = u.user_id
      INNER JOIN trackable_metrics as tm
        ON tm.asset_id = da.digital_asset_id
      WHERE da.digital_asset_id IS NOT NULL;"
  end

  def down
    execute 'DROP MATERIALIZED VIEW IF EXISTS digital_asset_report;'
  end

end
