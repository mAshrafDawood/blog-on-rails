class CreateTags < ActiveRecord::Migration[8.0]
    def change
        create_table :tags do |t|
            t.string :body
            t.belongs_to :post, null: false, foreign_key: true

            t.timestamps
        end
    end
end
