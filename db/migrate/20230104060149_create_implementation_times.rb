class CreateImplementationTimes < ActiveRecord::Migration[6.1]
  def change
    create_table :implementation_times do |t|

      t.time :accurate_time
      t.string :approximate_time

      t.timestamps
    end
  end
end
