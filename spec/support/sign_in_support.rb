module SignInSupport
  def sign_in(user)
    # トップページに移動する
    visit root_path
    # トップページに新規登録ページへ遷移するボタンがある
    expect(page).to have_content('新規登録')
    # トップページにログインページへ遷移するボタンがある
    expect(page).to have_content('ログイン')
    # ログインボタンをクリック
    click_on 'ログイン'
    # ユーザー情報を入力する
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    # ログインボタンを押す
    find('input[name="commit"]').click
    # トップページへ遷移する
    expect(page).to have_current_path(root_path)
  end
end