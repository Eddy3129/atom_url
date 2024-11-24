# frozen_string_literal: true

# Establishes ApplicationRecord as the primary abstract class
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
