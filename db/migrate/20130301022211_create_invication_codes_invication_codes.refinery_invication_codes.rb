# This migration comes from refinery_invication_codes (originally 1)
class CreateInvicationCodesInvicationCodes < ActiveRecord::Migration

  def up
    create_table :refinery_invication_codes do |t|
      t.datetime :begin_at
      t.datetime :end_at
      t.string :code
      t.string :user_type
      t.integer :user_id
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-invication_codes"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/invication_codes/invication_codes"})
    end

    drop_table :refinery_invication_codes

  end

end
