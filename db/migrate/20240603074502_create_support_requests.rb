class CreateSupportRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :support_requests do |t|
      t.string :email, comment: "Email of the submitter"
      t.string :subject, comment: "Subject of their support email"
      t.text :body, comment: "Body of their support email"
      t.references :intervention, foreign_key: true
      t.timestamps
    end
  end
end
