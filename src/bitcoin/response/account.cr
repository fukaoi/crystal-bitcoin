require "json"

# JSONレスポンスをCrystal objectに変換
#
module Bitcoin::Response
  class Account
    JSON.mapping(
      address: String,
      secret: String,
      pubkey: String,
      type: String
    )
  end
end
