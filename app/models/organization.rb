class Organization < ApplicationRecord
  has_many :values
  belongs_to :category
  belongs_to :city
  accepts_nested_attributes_for :values
  validates_presence_of :title, :address, message: 'Не может быть пустым'
  has_many :children, class_name: 'Organization', foreign_key: 'parent_id'
  include SettingsStateMachine

  after_initialize :set_initial_status

  def set_initial_status
    self.state ||= :draft
  end

  def self.states_list
    [:draft, :published, :moderation]
  end

  searchable do
    text    :title
    text    :string_values do
      values.map(&:string_value).compact
    end
    string  :state
  end

  def parent
    Organization.where(:id => parent_id).first
  end

  def user
    User.find_by id: user_id
  end

  def owner?(some_user)
    user == some_user
  end

  def is_child?
    !parent_id.nil?
  end
end
