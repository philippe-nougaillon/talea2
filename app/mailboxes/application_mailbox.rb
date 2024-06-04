class ApplicationMailbox < ActionMailbox::Base
  # routing /something/i => :somewhere
  routing "support@mg.talea2.fr" => :support
end
