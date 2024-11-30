# frozen_string_literal: true

# app/controllers/sessions_controller.rb

# This controller handles user sign-in and sign-out operations for the application
class SessionsController < Devise::SessionsController
  # @method create
  # Authenticates and signs in the user, associates unassigned URLs with the user.
  #
  # @param auth_options [Hash] Options used for user authentication.
  # @return [void]
  def create
    authenticate_and_sign_in_user
    associate_urls_with_user

    respond_to do |format|
      format.turbo_stream do
        render_turbo_stream_after_create
        return # Ensure that the action terminates after rendering the turbo stream
      end
      format.html do
        redirect_to after_sign_in_path_for(resource)
        return # Ensure that execution halts after redirect
      end
    end
  end

  # @method destroy
  # Signs out the user and responds with an appropriate Turbo Stream or HTML format.
  def destroy
    sign_out_user

    respond_to do |format|
      format.turbo_stream do
        render_turbo_stream_after_destroy
        return # Ensure that the action terminates after rendering the turbo stream
      end
      format.html do
        redirect_to after_sign_out_path_for(resource_name)
        return # Ensure that execution halts after redirect
      end
    end
  end

  protected

  # @method after_sign_in_path_for
  # Redirects the user after successful sign-in.
  #
  # @param _resource [User] The user that was signed in.
  # @return [String] The path to redirect the user to.
  def after_sign_in_path_for(_resource)
    root_path
  end

  # @method after_sign_out_path_for
  # Redirects the user after sign-out.
  #
  # @param _resource_or_scope [User, String] The user or scope being signed out.
  # @return [String] The path to redirect the user to.
  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  private

  # @method Authenticate and sign in the user
  def authenticate_and_sign_in_user
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
  end

  # @method Associate all unassigned URLs with the logged-in user
  def associate_urls_with_user
    return unless current_user

    Url.where(user_id: nil).find_each do |url|
      url.update(user_id: current_user.id)
    end
  end

  # @method Render turbo stream after successful sign-in
  def render_turbo_stream_after_create
    render turbo_stream: turbo_stream.replace(
      'modal',
      partial: 'devise/shared/redirect',
      locals: { path: after_sign_in_path_for(resource) }
    )
  end

  # @method Sign out the user
  def sign_out_user
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message!(:notice, :signed_out) if signed_out
    yield if block_given?
  end

  # @method Render turbo stream after sign-out
  def render_turbo_stream_after_destroy
    render turbo_stream: turbo_stream.replace(
      'modal',
      partial: 'devise/shared/redirect',
      locals: { path: after_sign_out_path_for(resource_name) }
    )
  end
end
