# require "test_helper"

# class SupportMailboxTest < ActionMailbox::TestCase
#   test "we create a SupportRequest when we get a support email" do
#     reveice_inbound_email_from_mail(to: "intervention@talea2.fr", from: "dupont.thierry@gmail.com", subject: "Need help", body: "I can't figure out how to check out!!")

#     support_request = SupportRequest.last
#     assert_equal "dupont.thierry@gmail.com", support_request.email
#     assert_equal "Need help", support_request.subject
#     assert_equal "I can't figure out how to check out!!", support_request.body
#     assert_nil support_request.order
#   end
# end