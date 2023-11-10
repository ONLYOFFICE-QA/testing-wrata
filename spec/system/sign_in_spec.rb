# frozen_string_literal: true

describe 'the sign in process' do
  it 'signing in with fake user result in failure' do
    visit '/sessions/new'
    fill_in('Login', with: 'test@example.com')
    fill_in('Password', with: '12345678')
    click_button('Log in')
    expect(page).to have_content 'Invalid login/password'
  end

  it 'siging in with created user result in success' do
    client = Client.create(login: 'user@example.com', password: 'password')
    visit '/sessions/new'
    fill_in('Login', with: client.login)
    fill_in('Password', with: client.password)
    click_button('Log in')
    expect(page).not_to have_content 'Invalid login/password'
  end
end
