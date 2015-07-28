# require_relative "enrollment"
# require_relative "course"

class User < ActiveRecord::Base
  has_many(
      :enrollments,
      :class_name => "Enrollment",
      :foreign_key => :student_id,
      :primary_key => :id
  )

  has_many :enrolled_courses, :through => :enrollments, :source => :course
end
