class CreateSaleoffCodesSaleoffCodes < ActiveRecord::Migration

  def up
    create_table :refinery_saleoff_codes do |t|
      t.datetime :begin_at
      t.datetime :end_at
      t.string :code
      t.float :percent
      t.integer :user_id
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-saleoff_codes"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/saleoff_codes/saleoff_codes"})
    end

    drop_table :refinery_saleoff_codes

  end

end
