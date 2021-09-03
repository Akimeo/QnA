class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :status, null: false, default: 0
      t.belongs_to :author, null: false, foreign_key: { to_table: :users }
      t.belongs_to :votable, polymorphic: true

      t.timestamps
    end
  end
end
