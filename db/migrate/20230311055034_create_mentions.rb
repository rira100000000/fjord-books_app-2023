class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.belongs_to :mention_report, null: false
      t.belongs_to :mentioned_report, null: false
      
      t.timestamps
    end
  end
end
