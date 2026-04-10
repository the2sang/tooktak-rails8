class OmniauthCallbacksController < ApplicationController
  allow_unauthenticated_access

  def google
    auth = request.env["omniauth.auth"]

    user = User.from_omniauth(auth)

    if user.persisted?
      start_new_session_for user
      redirect_to after_authentication_url, notice: "Google 계정으로 로그인되었습니다."
    else
      redirect_to new_session_path, alert: "Google 로그인에 실패했습니다: #{user.errors.full_messages.join(', ')}"
    end
  end

  def failure
    redirect_to new_session_path, alert: "인증에 실패했습니다. 다시 시도해 주세요."
  end
end
