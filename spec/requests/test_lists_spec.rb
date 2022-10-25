# frozen_string_literal: true

require 'rails_helper'
RSpec.describe '/test_lists' do
  fixtures(:clients)

  let(:valid_attributes) do
    { name: 'Test List 1', client_id: clients(:one).id }
  end

  let(:invalid_attributes) do
    { name: 'a' }
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      TestList.create! valid_attributes
      get test_lists_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      test_list = TestList.create! valid_attributes
      get test_list_url(test_list)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_test_list_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      test_list = TestList.create! valid_attributes
      get edit_test_list_url(test_list)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new TestList' do
        expect do
          post test_lists_url, params: { test_list: valid_attributes }
        end.to change(TestList, :count).by(1)
      end

      it 'redirects to the created test_list' do
        post test_lists_url, params: { test_list: valid_attributes }
        expect(response).to redirect_to(test_list_url(TestList.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new TestList' do
        expect do
          post test_lists_url, params: { test_list: invalid_attributes }
        end.not_to change(TestList, :count)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post test_lists_url, params: { test_list: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'Test List 2', client_id: clients(:one).id }
      end

      it 'updates the requested test_list' do
        test_list = TestList.create! valid_attributes
        patch test_list_url(test_list), params: { test_list: new_attributes }
        test_list.reload
        expect(test_list[:name]).to eq(new_attributes[:name])
      end

      it 'redirects to the test_list' do
        test_list = TestList.create! valid_attributes
        patch test_list_url(test_list), params: { test_list: new_attributes }
        test_list.reload
        expect(response).to redirect_to(test_list_url(test_list))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        test_list = TestList.create! valid_attributes
        patch test_list_url(test_list), params: { test_list: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested test_list' do
      test_list = TestList.create! valid_attributes
      expect do
        delete test_list_url(test_list)
      end.to change(TestList, :count).by(-1)
    end

    it 'redirects to the test_lists list' do
      test_list = TestList.create! valid_attributes
      delete test_list_url(test_list)
      expect(response).to be_successful
    end
  end
end
