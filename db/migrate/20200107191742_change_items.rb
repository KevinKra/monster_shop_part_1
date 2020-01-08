class ChangeItems < ActiveRecord::Migration[5.1]
  def change
    change_column_default :items, :image, "https://www.valuewalk.com/wp-content/uploads/2016/09/Default-Image-ValueWalk.jpg"
  end
end
