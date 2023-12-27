# frozen_string_literal: true

class AccessPermission < ApplicationRecord
  belongs_to :<%= singular_model_name %>

  validates :controller_path, uniqueness: { scope: :<%= singular_model_name %>_id }
end
