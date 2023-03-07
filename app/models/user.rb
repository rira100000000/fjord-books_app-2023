# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  validate :avatar_format
  def avatar_format
    return unless avatar.attached?

    allowed_types = ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']

    unless avatar.blob.content_type.in?(allowed_types)
      errors.add(:avatar, 'はjpeg、jpg、png、gif形式のみ許可されています')
    end
  end
end
