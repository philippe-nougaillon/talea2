require 'dry/events/publisher'

class Events
  include Singleton
  include Dry::Events::Publisher[:my_publisher]

  register_event('intervention.workflow_changed')
  register_event('intervention.updated')
  register_event('intervention.done')
end