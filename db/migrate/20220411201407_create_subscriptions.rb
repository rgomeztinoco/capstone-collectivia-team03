class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :user, :topic, table_name: :subscriptions do |t|
      t.index [:user_id, :topic_id], unique:  true
      # t.index [:topic_id, :user_id]
    end
  end
end
