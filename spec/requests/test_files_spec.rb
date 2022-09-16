# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/test_files', type: :request do
  fixtures(:test_lists)

  let(:valid_attributes) do
    { name: 'file.1', test_list_id: test_lists(:one).id }
  end

  let(:invalid_attributes) do
    { name: 'only.file' }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      TestFile.create! valid_attributes
      get test_files_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      test_file = TestFile.create! valid_attributes
      get test_file_url(test_file)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_test_file_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      test_file = TestFile.create! valid_attributes
      get edit_test_file_url(test_file)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new TestFile' do
        expect do
          post test_files_url, params: { test_file: valid_attributes }
        end.to change(TestFile, :count).by(1)
      end

      it 'redirects to the created test_file' do
        post test_files_url, params: { test_file: valid_attributes }
        expect(response).to redirect_to(test_file_url(TestFile.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new TestFile' do
        expect do
          post test_files_url, params: { test_file: invalid_attributes }
        end.not_to change(TestFile, :count)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post test_files_url, params: { test_file: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'file.2' }
      end

      it 'updates the requested test_file' do
        test_file = TestFile.create! valid_attributes
        patch test_file_url(test_file), params: { test_file: new_attributes }
        test_file.reload
        expect(test_file[:name]).to eq(new_attributes[:name])
      end

      it 'redirects to the test_file' do
        test_file = TestFile.create! valid_attributes
        patch test_file_url(test_file), params: { test_file: new_attributes }
        test_file.reload
        expect(response).to redirect_to(test_file_url(test_file))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        test_file = TestFile.create! valid_attributes
        patch test_file_url(test_file), params: { test_file: invalid_attributes }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested test_file' do
      test_file = TestFile.create! valid_attributes
      expect do
        delete test_file_url(test_file)
      end.to change(TestFile, :count).by(-1)
    end

    it 'redirects to the test_files list' do
      test_file = TestFile.create! valid_attributes
      delete test_file_url(test_file)
      expect(response).to redirect_to(test_files_url)
    end
  end
end
