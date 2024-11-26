# frozen_string_literal: true

# app/controllers/sessions_controller.rb

# This controller handles user sign-in and sign-out operations for the application
class SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    authenticate_and_sign_in_user

    associate_urls_with_user

    respond_to do |format|
      format.turbo_stream { render_turbo_stream_after_create }
      format.html { redirect_to after_sign_in_path_for(resource) }
    end
  end

  # DELETE /resource/sign_out
  def destroy
    sign_out_user

    respond_to do |format|
      format.turbo_stream { render_turbo_stream_after_destroy }
      format.html { redirect_to after_sign_out_path_for(resource_name) }
    end
  end

  protected

  def after_sign_in_path_for(_resource)
    root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  private

  # Authenticate and sign in the user
  def authenticate_and_sign_in_user
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
  end

  # Associate all unassigned URLs with the logged-in user
  def associate_urls_with_user
    return unless current_user

    Url.where(user_id: nil).find_each do |url|
      url.update(user_id: current_user.id)
    end
  end

  # Render turbo stream after successful sign-in
  def render_turbo_stream_after_create
    render turbo_stream: turbo_stream.replace(
      'modal',
      partial: 'devise/shared/redirect',
      locals: { path: after_sign_in_path_for(resource) }
    )
  end

  # Sign out the user
  def sign_out_user
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message!(:notice, :signed_out) if signed_out
    yield if block_given?
  end

  # Render turbo stream after sign-out
  def render_turbo_stream_after_destroy
    render turbo_stream: turbo_stream.replace(
      'modal',
      partial: 'devise/shared/redirect',
      locals: { path: after_sign_out_path_for(resource_name) }
    )
  end
end
