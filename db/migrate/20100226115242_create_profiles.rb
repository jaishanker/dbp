class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.column :user_id,                     :integer
      t.column :website,                      :string, :limit => 100
      t.column :comm_site_1,                      :string, :limit => 100
      t.column :comm_site_2,                      :string, :limit => 100
      t.column :comm_site_3,                      :string, :limit => 100
      t.column :blog_1,                      :string, :limit => 100
      t.column :blog_2,                      :string, :limit => 100
      t.column :blog_3,                      :string, :limit => 100      
      t.column :qualification_type,                     :integer, :limit => 4
      t.column :graduation_year,          :integer
      t.column :total_exp,          :integer 
      t.column :solidworks_associate,          :string, :limit => 5      
      t.column :cswp_surface_prof,           :string, :limit => 5      
      t.column :cswp_shetmetal_prof,           :string, :limit => 5      
      t.column :solidworks_version,                      :string, :limit => 50
      t.column :solidwork_usege_exp,                      :string, :limit => 50      
      t.column :cad_usage_exp,                      :string, :limit => 50
      t.column :sw_simulation_or_cosmos,                      :string, :limit => 50
      t.column :sw_flow_used,                      :string, :limit => 5      
      t.column :solidwork_simulation_usege_exp,                      :string, :limit => 50
      t.column :comparison_phy_testing,                       :string, :limit => 5         
      t.column :worked_on_solidworks,                       :string, :limit => 5      
      t.column :solidword_product_worked_on,                     :string, :limit => 1000
      t.column :skills,                     :string, :limit => 1000

      t.timestamps
    end
  end
  
  def self.down
    drop_table :profiles
  end
end
