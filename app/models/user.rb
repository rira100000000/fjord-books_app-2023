# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  validate :avatar_format
  def avatar_format
    return unless avatar.attached?

    allowed_types = %w[.jpg .jpeg .png .gif]
    unless allowed_types.include?(avatar.blob.content_type)
      errors.add(:avatar, 'はjpeg、jpg、png、gif形式のみ許可されています')
    end
  end
end
