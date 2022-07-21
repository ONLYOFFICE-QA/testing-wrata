# frozen_string_literal: true

describe 'Server History', type: :feature do
  it 'Opening incorrectr server history entry show correct 404' do
    client = Client.create(login: 'user@example.com', password: 'password')
    visit('/sessions/new')
    fill_in('Login', with: client.login)
    fill_in('Password', with: client.password)
    click_button('Log in')
    visit('/server_history/1000')
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
