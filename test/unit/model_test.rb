require 'test_helper'

class Email
  include RedisModel::Base
  ATTRS = [:id, :from, :to, :subject]
  attr_accessor *ATTRS

  def valid?
    true
  end
end


class ModelTest < ActiveSupport::TestCase
  def setup
    @model = Email.new
    @attrs = {from: 'a@a.com', to: 'b@b.com', subject: 'hello'}
  end

  def build
    Email.new(@attrs)
  end

  def create
    Email.create(@attrs)
  end

  test "should be able to save and retrieve model" do
    @email = build
    @email.save
    assert_equal @email.subject, Email.find(@email.id).subject
  end

  test "should be able to create and retrieve model" do
    @email = create
    assert_equal @email.subject, Email.find(@email.id).subject
  end

  test "record should get expired after TTL" do
    id = create.id
    assert Email.find(id)
    sleep REDIS_TTL + 0.2
    assert_nil Email.find(id)
  end

  test "should be able to update attributes" do
    @email = create
    to = 'm2@m.com, m3@m.com'
    from = 'm@m.com'
    @email.update_attributes({to: to, from: from})

    @email = Email.find(@email.id)
    assert_equal to, @email.to
    assert_equal from, @email.from
  end

  test "should be able to update attributes without calling update_attributes" do
    @email = create
    @email.to = to = 'm2@m.com, m3@m.com'
    @email.from = from = 'm@m.com'
    @email.save

    @email = Email.find(@email.id)
    assert_equal to, @email.to
    assert_equal from, @email.from
  end

  test "should set the id of the model when retreived" do
    id = create.id
    assert_equal id, Email.find(id).id
  end
end
