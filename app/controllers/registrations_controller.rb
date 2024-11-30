# frozen_string_literal: true

# This class handles user registration and editing passwords
class RegistrationsController < Devise::RegistrationsController
  # @param sign_up_params [ActionController::Parameters] The parameters used to sign up the user
  # @return [void]
  #
  # @method create
  # Handles user registration, creates a new user, associates unassigned URLs to the user.
  def create
    build_resource(sign_up_params)

    if resource.save
      handle_successful_creation
    else
      handle_failed_creation
    end
  end

  # @param account_update_params [ActionController::Parameters] The parameters used to update the user account
  # @return [void]
  #
  # @method update
  # Updates the user's account information and manages flash messages and redirection.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_resource(resource, account_update_params)
      handle_successful_update(prev_unconfirmed_email)
    else
      handle_failed_update
    end
  end

  protected

  # @method after_sign_up_path_for
  # Redirects the user after successful sign-up.
  #
  # @param _resource [User] The resource (user) that was created
  # @return [String] Returns to root path
  def after_sign_up_path_for(_resource)
    root_path
  end

  # @method after_update_path_for
  # Redirects the user after a successful account update.
  #
  # @param _resource [User] The resource (user) that was updated
  # @return [String] Returns to root path
  def after_update_path_for(_resource)
    root_path
  end

  private

  # @method Handle successful user creation
  def handle_successful_creation
    sign_up(resource_name, resource)
    set_flash_message!(:notice, :signed_up) if is_flashing_format?
    associate_urls_with_user(resource)
    respond_to_create_success
  end

  # @method Handle failed user creation
  def handle_failed_creation
    clean_up_passwords(resource)
    set_minimum_password_length
    respond_to_create_failure
  end

  # @method Handle successful update
  def handle_successful_update(prev_unconfirmed_email)
    flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ? :update_needs_confirmation : :updated
    set_flash_message :notice, flash_key
    bypass_sign_in resource, scope: resource_name
    respond_to_update_success
  end

  # @method Handle failed update (render errors)
  def handle_failed_update
    clean_up_passwords(resource)
    respond_to_update_failure
  end

  # @method Associate URLs with the new user
  def associate_urls_with_user(user)
    Url.where(user_id: nil).find_each do |url|
      url.update(user_id: user.id)
    end
  end

  # @method Respond to successful user creation
  def respond_to_create_success
    respond_to do |format|
      format.turbo_stream { render_turbo_stream_after_create }
      format.html { redirect_to after_sign_up_path_for(resource) }
    end
  end

  # @method Respond to failed user creation
  def respond_to_create_failure
    respond_to do |format|
      format.turbo_stream { render_failed_create_turbo_stream }
      format.html { render :new, status: :unprocessable_entity }
    end
  end

  # @method Turbo stream response after successful create
  def render_turbo_stream_after_create
    render turbo_stream: turbo_stream.replace(
      'modal',
      partial: 'devise/shared/redirect',
      locals: { path: after_sign_up_path_for(resource) }
    )
  end

  # @method Render failed create form in Turbo stream
  def render_failed_create_turbo_stream
    render turbo_stream: turbo_stream.replace(
      'modal',
      partial: 'devise/registrations/new',
      locals: { resource: resource }
    )
  end

  # @method Respond to successful update
  def respond_to_update_success
    respond_to do |format|
      format.turbo_stream { render_successful_update_turbo_stream }
      format.html { redirect_to after_update_path_for(resource) }
    end
  end

  # @method Respond to failed update
  def respond_to_update_failure
    respond_to do |format|
      format.turbo_stream { render_failed_update_turbo_stream }
      format.html { render :edit, status: :unprocessable_entity }
    end
  end

  # @method Turbo stream response after successful update
  def render_successful_update_turbo_stream
    render turbo_stream: turbo_stream.replace('modal', partial: 'devise/shared/redirect',
                                                       locals: { path: after_update_path_for(resource) })
  end

  # @method Render failed update form in Turbo stream
  def render_failed_update_turbo_stream
    render turbo_stream: turbo_stream.replace('modal', partial: 'devise/registrations/edit',
                                                       locals: { resource: resource })
  end
end
