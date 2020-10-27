require "../src/bitcoin"

to = "0xFd886c8f0c8185Ee814a74EB9cDcA2CfE910474C"

# ## Testnet or Mainnet or Custome net ###
Bitcoin.set_network(Bitcoin::Network::Testnet)

# ## generate p2sh account info ###
account1 = Bitcoin::Account.generate_account
account2 = Bitcoin::Account.generate_account
account3 = Bitcoin::Account.generate_account

# ## 2 of 3 sig address
address = Bitcoin::Account.generate_multisig_address(
  [
    account1.pubkey,
    account2.pubkey,
    account3.pubkey,
  ],
  2 # 2 sig
)

p address
