# frozen_string_literal: true

module Api
  module V1
    module Protected
      # Simple JSONAPI controller that offers up all the basic actions.
      # This instance is special because it's `SessionsResource` is set to immutable so only read-only access
      # to the Session model will be provided through this controller.
      #
      # An `invalidate` action has been added to this controller.  This allows sessions to be destroyed
      # application-side for security reasons.
      class SessionsController < ApplicationController
        include JSONAPI::ActsAsResourceController

        before_action :authorize_access_request!

        def invalidate
          # TODO: protect this action using Pundit so that only Administrator role can do it
          session = Session.find_by!(id: params[:id])

          jwt_session = JWTSessions::Session.new(payload: payload)

          # TODO: the following flush will throw an JWTSessions::Errors::Unauthorized exception if the refresh token
          # cannot be found; what should we do?
          jwt_session.flush_by_uid(session.ruid)

          session.update!(invalidated: true, invalidated_by: current_user)

          render json: { data: {}, meta: {} }, status: :no_content
        end
      end
    end
  end
end