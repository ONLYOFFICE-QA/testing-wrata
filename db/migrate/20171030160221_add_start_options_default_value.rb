class AddStartOptionsDefaultValue < ActiveRecord::Migration[5.1]
  def change
    change_column_default :start_options, :docs_branch, from: nil, to: 'develop'
    change_column_default :start_options, :teamlab_branch, from: nil, to: 'master'
    change_column_default :start_options, :portal_type, from: nil, to: 'info'
    change_column_default :start_options, :portal_region, from: nil, to: 'us'
    change_column_default :start_options, :spec_language, from: nil, to: 'en-us'
    change_column_default :start_options, :shared_branch, from: nil, to: 'master'
    change_column_default :start_options, :teamlab_api_branch, from: nil, to: 'develop'
  end
end
