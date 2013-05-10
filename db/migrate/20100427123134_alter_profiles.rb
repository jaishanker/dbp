class AlterProfiles < ActiveRecord::Migration
  def self.up
    change_column :profiles, :solidworks_version, :string, :limit => 150       
    add_column :profiles, :cswe,:string, :limit => 5      
    add_column :profiles, :cswp,:string, :limit => 5      
    add_column :profiles, :cswp_mold_tools,:string, :limit => 5      
    add_column :profiles, :cswsp,:string, :limit => 5          
    add_column :profiles, :simulation_version,:string, :limit => 150      
    add_column :profiles, :epdm_version,:string, :limit => 150    
    add_column :profiles, :solidworks_3d_version,:string, :limit => 150     
  end

  def self.down
    change_column :profiles, :solidworks_version, :string, :limit => 50       
    remove_column :profiles, :cswe
    remove_column :profiles, :cswp
    remove_column :profiles, :cswp_mold_tools
    remove_column :profiles, :cswsp
    remove_column :profiles, :simulation_version
    remove_column :profiles, :epdm_version
    remove_column :profiles, :solidworks_3d_version
  end
end
