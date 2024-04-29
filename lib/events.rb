require 'dry/events/publisher'

class Events
  include Singleton
  include Dry::Events::Publisher[:my_publisher]

  register_event('intervention.workflow_changed')
  register_event('intervention.termine')
  register_event('intervention.commentaires_changed')
end