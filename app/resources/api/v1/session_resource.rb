# frozen_string_literal: true

module Api
  module V1
    # Protected access to the `Session` model.
    # Note that the RUID is not ever exposed or sent to through the wire.
    class SessionResource < BaseResource
      immutable # no CUD through controller

      # Attributes
      # ----------------------------------------------------------------------------------------------------------------

      # Notice that we're not serializing the RUID column; keep that hidden to the public
      attributes(
        :browser,
        :browser_version,
        :device,
        :expiring_at,
        :invalidated,
        :ip_address,
        :platform,
        :platform_version,
        {}
      )

      # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
      def self.updatable_fields(_context)
        [] # immutable
      end

      # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
      def self.creatable_fields(_context)
        [] # immutable
      end

      # Relationships
      # ----------------------------------------------------------------------------------------------------------------

      has_one :invalidated_by

      has_one :user
    end
  end
end
