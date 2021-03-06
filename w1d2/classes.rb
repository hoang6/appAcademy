class Student

  def initialize(first, last)
    @first = first
    @last = last
    @courses = []
  end

  def name
    "#{@first} #{@last}"
  end

  def courses
    @courses
  end

  def enroll(course)
    unless (course.students).include?(self.name) || has_conflict?
      @courses << course
      course.students << self.name
    end
  end

  def has_conflict?
    (0..@courses.count - 2).each do |idx1|
      (idx1 + 1..@courses.count - 1).each do |idx2|
        return true if courses[idx1].course_conflict?(courses[idx2])
      end
    end
    false
  end

  def course_load
    loads = Hash.new(0)

    @courses.each do |course|
      loads[course.department] += course.units
    end

    loads
  end
end

class Course
  attr_reader :course_name, :department, :units, :dates, :time
  attr_accessor :students

  def initialize(course_name, department, units, dates, time)
    @course_name = course_name
    @department = department
    @units = units
    @students = []
    @dates = dates
    @time = time
  end

  # def students
  #    @students
  # end

  def add_student(student)
    @students << student
  end

  def course_conflict?(course)
    same_day = false
    (course.dates).each do |day|
      same_day = true if @dates.include?(day)
    end
    same_time = true if @time == course.time

    return true if same_day && same_time
    false
  end
end


brian = Student.new("Brian", "Smith")
mary = Student.new("Mary", "Smith")
john = Student.new("John", "Smith")

physics0 = Course.new('Physics 101', 'Physics', 3, [:mon, :wed, :fri], 1)
physics1 = Course.new('Physics 102', 'Physics', 4, [:tue, :sat, :sun], 1)
physics2 = Course.new('Physics 102', 'Math', 4, [:mon, :wed, :fri], 6)
physics3 = Course.new('Physics 301', 'Chemistry', 4, [:mon, :wed, :fri], 8)

# p physics0.course_conflict?(physics1)


brian.enroll(physics0)
brian.enroll(physics1)

# p brian.courses
# p physics1.students

brian.enroll(physics1)
mary.enroll(physics1)
john.enroll(physics1)
# p physics1.students
brian.enroll(physics2)
brian.enroll(physics3)
# p physics1.students
# puts "-------------"
p brian.course_load
