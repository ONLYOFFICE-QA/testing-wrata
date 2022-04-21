# frozen_string_literal: true

describe 'the sign in process', type: :feature do
  it 'signing in with fake user result in failure' do
    visit '/sessions/new'
    fill_in('Login', with: 'test@example.com')
    fill_in('Password', with: '12345678')
    click_button('Log in')
    expect(page).to have_content 'Invalid login/password'
  end
end
