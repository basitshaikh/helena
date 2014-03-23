module Helena
  module Admin
    module Questions
      class CheckboxGroupsController < Admin::QuestionsController
        private

        def question_params
          params.require(:questions_checkbox_group).permit(:question_text,
                                                           :code,
                                                           :type,
                                                           :required,
                                                           sub_questions_attributes: sub_questions_attributes).merge(version_id: @version.id)
        end

        def add_ressources
          @question.sub_questions.build
        end
      end
    end
  end
end
