# frozen_string_literal: true

describe 'the sign in process', type: :feature, js: true do
  it 'Test List can be created on History page' do
    client = Client.create(login: 'user@example.com', password: 'password')
    Server.create(id: 1, name: 'server1', address: '192.168.0.0')
    visit '/sessions/new'
    fill_in('Login', with: client.login)
    fill_in('Password', with: client.password)
    click_button('Log in')
    sleep 10
    visit '/server_history/1'
    click_link('Test Lists')
    find(:xpath, '//ul[@id="test_list_menu"]/a').click
    expect(page).to have_content 'New Test List'
  end
end
