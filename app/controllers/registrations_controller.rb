# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      sign_up(resource_name, resource)
      set_flash_message!(:notice, :signed_up) if is_flashing_format?
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'modal',
            partial: 'devise/shared/redirect',
            locals: { path: after_sign_up_path_for(resource) }
          )
        end
        format.html do
          redirect_to after_sign_up_path_for(resource), notice: 'Welcome! You have signed up successfully.'
        end
      end
    else
      clean_up_passwords(resource)
      set_minimum_password_length
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'modal',
            partial: 'devise/registrations/new',
            locals: { resource: resource }
          )
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_resource(resource, account_update_params)
      yield resource if block_given?
      if is_flashing_format?
        flash_key = if update_needs_confirmation?(resource, prev_unconfirmed_email)
                      :update_needs_confirmation
                    else
                      :updated
                    end
        set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'modal',
            partial: 'devise/shared/redirect',
            locals: { path: after_update_path_for(resource) }
          )
        end
        format.html do
          redirect_to after_update_path_for(resource), notice: 'Your account has been updated successfully.'
        end
      end
    else
      clean_up_passwords(resource)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'modal',
            partial: 'devise/registrations/edit',
            locals: { resource: resource }
          )
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  protected

  def after_sign_up_path_for(_resource)
    root_path
  end

  def after_update_path_for(_resource)
    root_path
  end
end
