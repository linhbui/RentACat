module UsersHelper
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(SecureRandom::urlsafe_base64(16))
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, class: "gravatar")
  end
end
