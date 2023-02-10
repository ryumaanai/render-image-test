# コチラは受講生提供用のコードではありません

require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '有効な情報で新規登録を行うと、レコードが1つ増え、トップページへ遷移すること' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録ページへ遷移するボタンがある
      expect(page).to have_content('新規登録')
      # トップページにログインページへ遷移するボタンがある
      expect(page).to have_content('ログイン')
      # 新規登録ボタンをクリック
      click_on '新規登録'
      # ユーザー情報を入力する
      fill_in 'user[nickname]', with: @user.nickname
      fill_in 'user[email]', with: @user.email
      fill_in 'user[password]', with: @user.password
      fill_in 'user[password_confirmation]', with: @user.password
      fill_in 'user[last_name]', with: @user.last_name
      fill_in 'user[first_name]', with: @user.first_name
      fill_in 'user[last_name_kana]', with: @user.last_name_kana
      fill_in 'user[first_name_kana]', with: @user.first_name_kana
      select '1930', from: 'user[birth_date(1i)]'
      select '1', from: 'user[birth_date(2i)]'
      select '1', from: 'user[birth_date(3i)]'
      # 会員登録ボタンを押すとユーザーモデルのカウントが1上がる
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(1)
      # トップページへ遷移する
      expect(page).to have_current_path(root_path)
      # 登録したニックネームが表示されている
      expect(page).to have_content(@user.nickname)
      # ログアウトボタンが表示されている
      expect(page).to have_content('ログアウト')
      # 新規登録の文字が消えている
      expect(page).to have_no_content('新規登録')
      # ログインの文字が消えている
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ユーザー新規登録ができないとき' do
    it '無効な情報で新規登録を行うと、新規登録画面にて、エラーが表示されること' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録ページへ遷移するボタンがある
      expect(page).to have_content('新規登録')
      # トップページにログインページへ遷移するボタンがある
      expect(page).to have_content('ログイン')
      # 新規登録ボタンをクリック
      click_on '新規登録'
      # 間違ったユーザー情報を入力する
      fill_in 'user[nickname]', with: ''
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]', with: ''
      fill_in 'user[last_name]', with: ''
      fill_in 'user[first_name]', with: ''
      fill_in 'user[last_name_kana]', with: ''
      fill_in 'user[first_name_kana]', with: ''
      # 会員登録ボタンを押してもユーザーモデルのカウントは上がらない
      expect{
        find('input[name="commit"]').click
      }.to change { User.count }.by(0)
      # 新規登録ページへ戻される
      expect(page).to have_content("会員情報入力") #renderしているため、current_pathが使えない？パス情報が変わる
      expect(page).to have_css "div.error-alert"
      # 入力がされていないことに対するエラーメッセージ
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
      expect(page).to have_content("Nickname can't be blank")
      expect(page).to have_content("Last name can't be blank")
      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name kana can't be blank")
      expect(page).to have_content("First name kana can't be blank")
      expect(page).to have_content("Birth date can't be blank")
      # カスタムエラーメッセージ
      expect(page).to have_content("Password is invalid. Include both letters and numbers")
      expect(page).to have_content("Last name is invalid. Input full-width characters")
      expect(page).to have_content("First name is invalid. Input full-width characters")
      expect(page).to have_content("Last name kana is invalid. Input full-width katakana characters")
      expect(page).to have_content("First name kana is invalid. Input full-width katakana characters")
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインができるとき' do 
    it '有効な情報でログインを行うと、トップページへ遷移すること' do
      # ログインする
      sign_in(@user)
      # ログアウトの文字が表示されている
      expect(page).to have_content('ログアウト')
      # 登録したニックネームが表示されている
      expect(page).to have_content(@user.nickname)
      # 新規登録の文字が消えている
      expect(page).to have_no_content('新規登録')
      # ログインの文字が消えている
      expect(page).to have_no_content('ログイン')
    end
  end

  context 'ログインができないとき' do 
    it '無効な情報でログインを行うと、ログインページにて、エラーメッセージ が表示されること' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録ページへ遷移するボタンがある
      expect(page).to have_content('新規登録')
      # トップページにログインページへ遷移するボタンがある
      expect(page).to have_content('ログイン')
      # ログインボタンをクリック
      click_on 'ログイン'
      # ユーザー情報を入力する
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      # ログインボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻される
      expect(page).to have_content("会員情報入力")
      # ログインページでエラーメッセージが表示されている
      expect(page).to have_content('Invalid Email or password.')
    end
  end
end

RSpec.describe 'ログアウト', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
    
  context 'ログアウトができるとき' do
    it 'ログイン状態のユーザーは、ログアウトボタンを押すとログアウトができること' do
      # ログインする
      sign_in(@user)
      # ログアウトの文字が表示されている
      expect(page).to have_content('ログアウト')
      # 登録したニックネームが表示されている
      expect(page).to have_content(@user.nickname)
      # 新規登録の文字が消えている
      expect(page).to have_no_content('新規登録')
      # ログインの文字が消えている
      expect(page).to have_no_content('ログイン')
      # ログアウトボタンをクリック
      click_on 'ログアウト'
      # トップページへ遷移する
      expect(page).to have_current_path(root_path)
      # 新規登録の文字が表示されている
      expect(page).to have_content('新規登録')
      # ログインの文字が表示されている
      expect(page).to have_content('ログイン')
      # ログアウトの文字が消えている
      expect(page).to have_no_content('ログアウト')
      # 登録したニックネームが消えている
      expect(page).to have_no_content(@user.nickname)
    end
  end
end