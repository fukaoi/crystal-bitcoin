require "../src/bitcoin"

from = {
  address: "2N9ihiKDG3Md7WgnkWTLoo5zMV6bZS9A1iz",
  secret:  "f73272974c57c13d8abd91fc0b62896d77b5426be9d4ce471cf0009a6795ba1c",
  pubkey: "024873368acf40b05372e2ac5eaa46a24bad56406621183da42d70e4e43708f87e"
}
to = "2N9fi9DvDJXmGQkW3U9XMfLatVmSy4t3P4b"

# ## Testnet or Mainnet or Custome net ###
Bitcoin.set_network(Bitcoin::Network::Testnet)

utxo = {
  txid: "83993e29bc0de92bc87de5da3fcc121e048af28e3a515082cf5df709670eb274",
  balance: "0.03727492",
  index: 1,
}


# ## Send transaction ###
p Bitcoin::Payment.send(
  from_account: {
    address: from[:address],
    secret: from[:secret],
    pubkey: from[:pubkey]
  },
  to: to,
  amount: "0.0000001",
  utxos: [utxo]
)
