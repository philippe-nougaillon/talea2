class ApplicationMailbox < ActionMailbox::Base
  # routing /something/i => :somewhere
  routing "support@talea2.fr" => :support
end
