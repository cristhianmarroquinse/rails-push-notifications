class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.string :email
      t.text :token
      t.string :sessionId

      t.timestamps
    end
  end
end
