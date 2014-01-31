class CreateLabelTemplates < ActiveRecord::Migration
  def change
    create_table :spree_label_templates do |t|
      t.string :name
      t.string :group

      t.timestamps
    end
  end
  
  def down
    drop_table :spree_label_templates
  end
end
