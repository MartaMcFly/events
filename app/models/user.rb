class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
has_many :created_events, class_name: "Event", foreign_key: "user_id", dependent: :destroy
has_and_belongs_to_many :attended_events, join_table: "events_users", class_name: "Event"
end
