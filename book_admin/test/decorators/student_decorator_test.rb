require 'test_helper'

class StudentDecoratorTest < ActiveSupport::TestCase
  def setup
    @student = Student.new.extend StudentDecorator
  end

  # test "the truth" do
  #   assert true
  # end
end
