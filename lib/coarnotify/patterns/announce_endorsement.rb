# frozen_string_literal: true

require_relative '../core/notify'
require_relative '../core/activity_streams2'

module Coarnotify
  module Patterns
    # Pattern to represent an AnnounceEndorsement notification
    class AnnounceEndorsement < Core::Notify::NotifyPattern
      def self.type_constant
        [Core::ActivityStreams2::ActivityStreamsTypes::ANNOUNCE, Core::Notify::NotifyTypes::ENDORSEMENT_ACTION]
      end

      # Get a context specific to Announce Endorsement
      #
      # @return [AnnounceEndorsementContext, nil] The Announce Endorsement context object
      def context
        c = get_property(Core::ActivityStreams2::Properties::CONTEXT)
        return unless c

        AnnounceEndorsementContext.new(stream: c, validate_stream_on_construct: false,
                                       validate_properties: @validate_properties, validators: @validators,
                                       validation_context: Core::ActivityStreams2::Properties::CONTEXT,
                                       properties_by_reference: @properties_by_reference)
      end

      # Set the context property of the notification
      #
      # @param value [AnnounceEndorsementContext] the context to set
      def context=(value)
        set_property(Core::ActivityStreams2::Properties::CONTEXT, value.doc)
      end

      # Extends the base validation to make `context` required
      #
      # @return [Boolean] true if valid, otherwise raises ValidationError
      def validate
        ve = Coarnotify::ValidationError.new

        begin
          super
        rescue Coarnotify::ValidationError => e
          ve = e
        end

        required_and_validate(ve, Core::ActivityStreams2::Properties::CONTEXT, context)

        raise ve if ve.has_errors?

        true
      end
    end

    # Announce Endorsement context object, which extends the base NotifyObject
    # to allow us to pass back a custom AnnounceEndorsementItem
    class AnnounceEndorsementContext < Core::Notify::NotifyObject
      # Get a custom AnnounceEndorsementItem
      #
      # @return [AnnounceEndorsementItem, nil] the Announce Endorsement Item
      def item
        i = get_property(Core::Notify::NotifyProperties::ITEM)
        return unless i

        AnnounceEndorsementItem.new(stream: i, validate_stream_on_construct: false,
                                    validate_properties: @validate_properties, validators: @validators,
                                    validation_context: Core::Notify::NotifyProperties::ITEM,
                                    properties_by_reference: @properties_by_reference)
      end

      # Set the item property
      #
      # @param value [AnnounceEndorsementItem] the item to set
      def item=(value)
        set_property(Core::Notify::NotifyProperties::ITEM, value.doc)
      end
    end

    # Announce Endorsement Item, which extends the base NotifyItem to provide
    # additional validation
    class AnnounceEndorsementItem < Core::Notify::NotifyItem
      # Extends the base validation with validation custom to Announce Endorsement notifications
      #
      # * Adds type validation, which the base NotifyItem does not apply
      # * Requires the mediaType value
      #
      # @return [Boolean] true if valid, otherwise raises a ValidationError
      def validate
        ve = Coarnotify::ValidationError.new

        begin
          super
        rescue Coarnotify::ValidationError => e
          ve = e
        end

        required_and_validate(ve, Core::ActivityStreams2::Properties::TYPE, type)
        required(ve, Core::Notify::NotifyProperties::MEDIA_TYPE, media_type)

        raise ve if ve.has_errors?

        true
      end
    end
  end
end
