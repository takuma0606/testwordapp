class Word < ApplicationRecord
  validates:word,{presence: true, uniqueness: { scope: :user_id }}
  validates:meaning,{presence: true}
  validates:part_of_speech,{presence: true}
  validates_uniqueness_of :word, conditions: -> { with_deleted }
  acts_as_paranoid

  def self.search(user,pos)
    where(user_id: user, part_of_speech: pos)
  end

  def self.nonsearch(user)
    where(user_id: user)
  end
end
