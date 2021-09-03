class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :status, null: false, default: 0
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :votable, polymorphic: true

      t.timestamps
    end
  end
end
