class DeviseMailer < ::ActionMailer::Base

  # Sets who is sending the e-mail
  def self.sender=(value)
    @@sender = value
  end

  # Reads who is sending the e-mail
  def self.sender
    @@sender
  end
  self.sender = nil

  # Deliver confirmation instructions when the user is created or its email is
  # updated, and also when confirmation is manually requested
  def confirmation_instructions(record)
    setup_mail(record, :confirmation_instructions)
  end

  # Deliver reset password instructions when manually requested
  def reset_password_instructions(record)
    setup_mail(record, :reset_password_instructions)
  end

  private

    # Configure default email options
    def setup_mail(record, key)
      mapping = Devise::Mapping.find_by_class(record.class)
      raise "Invalid devise resource #{record}" unless mapping

      subject      translate(mapping, key)
      from         self.class.sender
      recipients   record.email
      sent_on      Time.now
      content_type 'text/html'
      body         render_with_scope(key, mapping, mapping.name => record, :resource => record)
    end

    def render_with_scope(key, mapping, assigns)
      if Devise.scoped_views
        begin
          render :file => "devise_mailer/#{mapping.as}/#{key}", :body => assigns
        rescue ActionView::MissingTemplate
          render :file => "devise_mailer/#{key}", :body => assigns
        end
      else
        render :file => "devise_mailer/#{key}", :body => assigns
      end
    end

    # Setup subject namespaced by model. It means you're able to setup your
    # messages using specific resource scope, or provide a default one.
    # Example (i18n locale file):
    #
    #   en:
    #     devise:
    #       mailer:
    #         confirmation_instructions: '...'
    #         user:
    #           confirmation_instructions: '...'
    def translate(mapping, key)
      I18n.t(:"#{mapping.name}.#{key}", :scope => [:devise, :mailer], :default => key)
    end
end
