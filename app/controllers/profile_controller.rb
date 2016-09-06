class ProfileController < ApplicationController

    def myprofile
        # @sprints = SprintSummary.uniq.pluck(:sprint_id)
        @user = current_user
        @sprints = current_user.group.sprints # can be empty if the user doesn't have any sprints and cause a bug(need to address this)
        @sprint = params[:sprint_id].present? ? Sprint.find(params[:sprint_id]) : @sprints.first
        
        # we need this in case if a AJAX request is received
        @sprint_index = @sprints.index(@sprint) + 1

        @maximum_points = capitalize_page_type(@sprint.total_points) # can be an empty array
        @student_points = @sprint.student_points(current_user.id)
        @student_points = capitalize_page_type(@student_points) # can be an empty array

        @max_total_points, @max_student_points = 0, 0
        @data = []

        # If the second array's size is less than the first, nil values are supplied
        # For more, see http://apidock.com/ruby/Array/zip

        if !@maximum_points.empty? and @maximum_points.length == @student_points.length
          @data = @maximum_points.zip(@student_points).map { |arr|
            { name: arr.first.first,
              y: arr.first.last,
              student_marks: arr.last.last
            }
          }

          @max_total_points = sum_points(@data, :y)
          @max_student_points = sum_points(@data, :student_marks)
        end

        respond_to do |format|
          format.html
          format.js
        end
    end

    def codereview
        @reviews = Review.where(user_id: current_user.id)
        @pages = Page.where(page_type: "codereview").order(:lesson_id)
    end


    private

    def capitalize_page_type points
      points.map {|element| [element[0].capitalize, element[1] ] }
    end

    def sum_points data_arr, page_type
      data_arr.map {|e| e[page_type]}.reduce(&:+)
    end
end
