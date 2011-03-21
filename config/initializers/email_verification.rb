# Set this to true if you want accounts to be verified by email.
# For this to work, Rails must be properly configured to send
# email. See config/application.rb for details.
#
# Also, note that verification information is stored in MongoDB.
# If you enable verification after you have active accounts,
# those accounts will be locked out. This can be fixed by
# adding a validated property to each user document and
# setting it to true.

EMAIL_VERIFICATION = true