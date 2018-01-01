
class Identity
  attr_accessor :email, :password, :user_agent, :socks_proxy, :session

  def initialize(email:, password:, user_agent:, socks_proxy:)
    self.email = email
    self.password = password
    self.user_agent = user_agent
    self.socks_proxy = socks_proxy
    self.session = Extractor::Session.new(
      email: email,
      password: password,
      user_agent: user_agent,
      profile_url_template: Rails.application.config.profile_url_template,
      socks_proxy: socks_proxy
    )
  end

  def
end
