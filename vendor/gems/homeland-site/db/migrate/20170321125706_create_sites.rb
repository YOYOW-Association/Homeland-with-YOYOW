class CreateSites < ActiveRecord::Migration[5.0]
  def up
    return if ActiveRecord::Base.connection.table_exists? :sites

    create_table 'site_nodes', force: :cascade do |t|
      t.string   'name',                   null: false
      t.integer  'sort', default: 0, null: false
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'site_nodes', ['sort'], name: 'index_site_nodes_on_sort', using: :btree

    create_table 'sites', force: :cascade do |t|
      t.integer  'user_id'
      t.integer  'site_node_id'
      t.string   'name',         null: false
      t.string   'url',          null: false
      t.string   'desc'
      t.datetime 'deleted_at'
      t.datetime 'created_at'
      t.datetime 'updated_at'
    end

    add_index 'sites', ['site_node_id'], name: 'index_sites_on_site_node_id', using: :btree
    add_index 'sites', ['url'], name: 'index_sites_on_url', using: :btree
    add_index :sites, [:site_node_id, :deleted_at]
  end

  def down
    drop_table :sites, if_exists: true
    drop_table :site_nodes, if_exists: true
  end
end
