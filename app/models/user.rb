# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  user_id                :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  name                   :string
#  role                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :trackable, :validatable

  class << self
    def create_or_update(attrs)
      user = User.where(user_id: attrs[:user_id]).first
      unless user.blank?
        user = user.update_attributes({
          name: attrs[:name],
          role: attrs[:role]
        })
      else
        password = SecureRandom.hex(10)
        attrs[:password] = password
        attrs[:password_confirmation] = password
        user = User.new(attrs)
        user.save!
      end
      user
    end
  end

end
