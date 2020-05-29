module API
  module Maintaining
    class ConceptExercisesController < BaseController
      def create
        example_filename_regexp = "[^a-zA-Z0-9._-]"
        exercise_slug_regexp = "[^a-zA-Z0-9-]"

        unless params[:exercise_track].present?
          return render_error(
            :missing_exercise_track,
            "Exercise track is missing"
          )
        end

        # TODO: verify/normalize track name

        unless params[:exercise_slug].present?
          return render_error(
            :missing_exercise_slug,
            "Exercise slug is missing"
          )
        end

        if params[:exercise_slug] =~ Regexp.new(exercise_slug_regexp)
          return render_error(
            :invalid_exercise_slug,
            "Exercise slug must match #{exercise_slug_regexp}"
          )
        end

        unless params[:example_filename].present?
          return render_error(
            :missing_example_filename,
            "Example filename is missing"
          )
        end

        if params[:example_filename] =~ Regexp.new(example_filename_regexp)
          return render_error(
            :invalid_example_filename,
            "Example filename must match #{example_filename_regexp}"
          )
        end

        uuid = SecureRandom.uuid
        tmp_path = Pathname.new("/tmp/#{uuid}")
        branch_name = "#{params[:exercise_track]}/#{params[:exercise_slug]}-#{uuid}"

        p tmp_path

        `git clone https://#{Rails.application.secrets.exercism_bot_credentials}@github.com/exercism-bot/v3.git #{tmp_path}`

        Dir.chdir(tmp_path) do
          `git remote add upstream https://github.com/exercism/v3.git`
          `git fetch upstream master`
          `git checkout --no-track -b #{branch_name} upstream/master`
        end

        File.open(tmp_path / "introduction.md", "w") {|f|f.write params[:introduction_markdown] }
        File.open(tmp_path / "design.md", "w") {|f|f.write params[:design_markdown] }
        File.open(tmp_path / params[:example_filename], "w") {|f|f.write params[:example_code] }

        Dir.chdir(tmp_path) do
          `git add .`
          `git config user.name #{current_user.name}`
          `git config user.email #{current_user.email}`
          `git commit -m "[#{params[:exercise_track]}] Add #{params[:exercise_slug]} Concept Exercise"`
          `git push origin #{branch_name}`
        end

        render json: {
          branch_name: branch_name
        }, status: 201
      end

      def render_error(type, msg)
        render json: {
          error: {
            type: type,
            message: msg
          }
        }, status: 400
      end
    end
  end
end

