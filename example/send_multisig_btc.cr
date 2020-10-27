require "../src/bitcoin"

from = {
  address: "2N9ihiKDG3Md7WgnkWTLoo5zMV6bZS9A1iz",

  # 2 signature in 2 of 3
  secrets: [
    "f73272974c57c13d8abd91fc0b62896d77b5426be9d4ce471cf0009a6795ba1c",
    "eb66ea1ff1819e03937efdb0d36b4004b29d1abe2e995a8f531c3b95479be8e0"
  ],
  # 3 pub key in 2 of 3
  pubkeys: [
    "024873368acf40b05372e2ac5eaa46a24bad56406621183da42d70e4e43708f87e",
    "035c715b16041a615ba18677a3431d7e3007d9edd7acb48da62ecbe85328f9ae7e",
    "029d9663807a95b29878fa45d2deefa84eca68f5f404504517a872b8ddc6341dd6"
  ]
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
p Bitcoin::Payment.send_by_multisig(
  multisig_account: from,
  sig_count: 2, # 2 signature
  to: to,
  amount: "0.0000001",
  utxos: [utxo]
)
