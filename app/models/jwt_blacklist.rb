class JwtBlacklist
  # Add methods here to manage JWT revocation, for example:
  def self.blacklist_token(token)
    # Logic for blacklisting the JWT token
  end

  def self.revoked?(token)
    # Logic to check if the token is revoked
  end
end
