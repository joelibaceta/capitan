# == Schema Information
#
# Table name: tracks
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string(255)
#  syllabus    :string(255)
#

class Track < ActiveRecord::Base
  has_many :courses

  def duration
    query = "select sum(duration) from units u join courses c on u.course_id = c.id join tracks t on c.track_id = t.id where t.id = #{self.id}"
    ActiveRecord::Base.connection.execute(query).first[0]
  end

  def teachers branch
    branch_name = branch.name.upcase
    puts branch_name
    teachers = []
    case branch_name
      when "LIMA"
        teachers = [ {name: "Giancarlo Corzo", image: "teachers/lima/gian.jpg", title: "Full Stack Developer", mail: "gian@laboratoria.la"},
                     {name: "Elizabeth Portilla", image: "teachers/lima/elizabeth.jpg", title: "Full Stack Developer", mail: "elizabeth@laboratoria.la"},
                     {name: "Iván Medina", image: "teachers/lima/ivan.jpg", title: "Back End Developer", mail: "ivan@laboratoria.la"}]
      when "MéXICO"
        teachers = [ {name: "Grissel Rocha", image: "teachers/mexico/grissel.jpg", title: "Full Stack Developer", mail: "grissel@laboratoria.mx"} ]
      when "CHILE"
        teachers = [ {name: "Blanca Pérez", image: "teachers/chile/blanca.jpg", title: "Full Stack Developer", mail: "blanca@laboratoria.cl"},
                     {name: "Matias Bensan", image: "teachers/chile/matias.jpg", title: "Full Stack Developer", mail: "matias@laboratoria.cl"}]
      when "AREQUIPA"
        teachers = [ {name: "Gerson Aduviri", image: "teachers/arequipa/gerson.jpg", title: "Full Stack Developer", mail: "gerson@laboratoria.la"} ]
    end
  end  
end
