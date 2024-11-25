# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'modal',
          partial: 'devise/shared/redirect',
          locals: { path: after_sign_in_path_for(resource) }
        )
      end
      format.html { redirect_to after_sign_in_path_for(resource) }
    end
  end

  # DELETE /resource/sign_out
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message! :notice, :signed_out if signed_out
    yield if block_given?
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'modal',
          partial: 'devise/shared/redirect',
          locals: { path: after_sign_out_path_for(resource_name) }
        )
      end
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
end
