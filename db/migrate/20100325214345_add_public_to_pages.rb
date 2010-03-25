class AddPublicToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :public, :boolean, :null=> false, :default=>false
  end

  def self.down
    remove_column :pages, :public
  end
end
