# frozen_string_literal: true

module Api
  module V1
    module Clone
      class CasesController < Api::ApiController
        before_action :find_case
        before_action :check_case

        # rubocop:disable Metrics/MethodLength
        def create
          @new_case = Case.new

          preserve_history  = params[:preserve_history]
          clone_queries     = params[:clone_queries]
          clone_ratings     = params[:clone_ratings]
          the_try           = @case.tries.where(tryNo: params[:tryNo]).first
          @new_case.caseName = params[:caseName].presence || "Cloned: #{@case.caseName}"

          transaction = @new_case.clone_case(
            @case,
            current_user,
            try:              the_try,
            preserve_history: preserve_history,
            clone_queries:    clone_queries,
            clone_ratings:    clone_ratings
          )

          if transaction
            respond_with @new_case
          else
            render status: :bad_request
          end
        end
        # rubocop:enable Metrics/MethodLength
      end
    end
  end
end
