class Notifier < ActionMailer::Base
  default from: 'noreply@berkmancenter.org',
          sent_on: Proc.new { Time.now }
          
  def case_notify_approved(case_obj, case_request)
    @case = case_obj
    mail(to: case_request.user.email_address, subject: "Case Request Approved")
  end

  def case_request_notify_rejected(case_request)
    @case_request = case_request
    mail(to: case_request.user.email_address, subject: "Case Request Not Accepted")
  end

  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(to: user.email_address, subject: "H2O Password Reset Instructions")
  end

  def logins(users)
    @new_password_reset_url = new_password_reset_url
    @users = users
    mail(to: users.map(&:email_address).uniq, subject: "H2O Logins")
  end
  
  def playlist_push_completed(user, playlist_name, new_playlist_id)
    @playlist_id = new_playlist_id
    mail(to: user.email_address, subject: "Push of Playlist #{playlist_name} completed")
  end

  def item_made_private(playlist, record)
    @playlist = playlist
    @record = record
    mail(to: playlist.user.email_address, subject: "Playlist Item Made Private")
  end

  def cases_list
    attachments['cases_list.csv'] = File.read("#{Rails.root}/tmp/cases_list.csv")
    mail(to: ['h2o@cyber.law.harvard.edu', 'awenner@cyber.law.harvard.edu', 'mmckay@law.harvard.edu', 'steph@endpoint.com'],
         subject: "List of All Cases #{Time.now.to_s(:simpledate)}")
  end

  def bulk_upload_completed(user, bulk_upload)
    @bulk_upload = bulk_upload
    @bulk_upload_url = bulk_upload_url(bulk_upload)
    mail(to: user.email_address, subject: "Bulk Upload Completed")
  end
end