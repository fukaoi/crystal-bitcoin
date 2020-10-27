require "../bitcoin_spec"
require "colorize"

describe Bitcoin::Account do
  describe "generate_account" do
    it "[P2SH]Create address and private key on Regtest" do
      Bitcoin.set_network(Bitcoin::Network::Regtest)
      res = Bitcoin::Account.generate_account
      puts "[REGTEST]".colorize(:blue)
      p res
      res.address.should_not be_nil
      res.secret.should_not be_nil
      res.pubkey.should_not be_nil
      res.type.should eq Bitcoin::Account::P2SH
    end

    it "[P2SH]Create address and private key on Testnet" do
      Bitcoin.set_network(Bitcoin::Network::Testnet)
      res = Bitcoin::Account.generate_account
      puts "[TESTNET]".colorize(:green)
      p res
      res.address.should_not be_nil
      res.secret.should_not be_nil
      res.pubkey.should_not be_nil
      res.type.should eq Bitcoin::Account::P2SH
    end

    it "[P2SH]Create address and private key on Mainnet" do
      Bitcoin.set_network(Bitcoin::Network::Mainnet)
      res = Bitcoin::Account.generate_account
      puts "[MAINNET]".colorize(:red)
      p res
      res.address.should_not be_nil
      res.secret.should_not be_nil
      res.pubkey.should_not be_nil
      res.type.should eq Bitcoin::Account::P2SH
    end

    it "[P2PKH]Create address and private key on Regtest" do
      Bitcoin.set_network(Bitcoin::Network::Regtest)
      res = Bitcoin::Account.generate_account(Bitcoin::Account::P2PKH)
      puts "[REGTEST]".colorize(:blue)
      p res
      res.address.should_not be_nil
      res.secret.should_not be_nil
      res.pubkey.should_not be_nil
      res.type.should eq Bitcoin::Account::P2PKH
    end

    it "[P2PKH]Create address and private key on Testnet" do
      Bitcoin.set_network(Bitcoin::Network::Testnet)
      res = Bitcoin::Account.generate_account(Bitcoin::Account::P2PKH)
      puts "[TESTNET]".colorize(:green)
      p res
      res.address.should_not be_nil
      res.secret.should_not be_nil
      res.pubkey.should_not be_nil
      res.type.should eq Bitcoin::Account::P2PKH
    end

    it "[P2PKH]Create address and private key on Mainnet" do
      Bitcoin.set_network(Bitcoin::Network::Mainnet)
      res = Bitcoin::Account.generate_account(Bitcoin::Account::P2PKH)
      puts "[MAINNET]".colorize(:red)
      p res
      res.address.should_not be_nil
      res.secret.should_not be_nil
      res.pubkey.should_not be_nil
      res.type.should eq Bitcoin::Account::P2PKH
    end
  end

  describe "is_address" do
    it "Is bitcoin address on Testnet" do
      address = "mtX8nPZZdJ8d3QNLRJ1oJTiEi26Sj6LQXS"
      res = Bitcoin::Account.is_address?(address)
      res.should be_true
    end

    it "Invalid bitcoin address on Testnet" do
      address = "97BahqRsFrAd3qLiNNwLNV3AWMRD7itxTo"
      res = Bitcoin::Account.is_address?(address)
      res.should be_false
    end

    it "Is bitcoin address on Mainnet" do
      address = "1Ewv7ZnDFhJ1BnWvwgBePa1rnArqcUk91b"
      res = Bitcoin::Account.is_address?(address)
      res.should be_true
    end
  end

  describe "get_address_type" do
    it "Get p2sh type" do
      account = Bitcoin::Account.generate_account
      res = Bitcoin::Account.get_address_type(account.address)
      res.should eq "p2sh"
    end

    it "Get p2pkh type" do
      account = Bitcoin::Account.generate_account(Bitcoin::Account::P2PKH)
      res = Bitcoin::Account.get_address_type(account.address)
      res.should eq "p2pkh"
    end
  end

  describe "generate_multisig_address" do
    it "Create multisig address" do
      account1 = Bitcoin::Account.generate_account(Bitcoin::Account::P2PKH)
      account2 = Bitcoin::Account.generate_account(Bitcoin::Account::P2PKH)
      account3 = Bitcoin::Account.generate_account(Bitcoin::Account::P2PKH)
      pub_keys = [
        account1.pubkey,
        account2.pubkey,
        account3.pubkey,
      ]
      address = Bitcoin::Account.generate_multisig_address(pub_keys, 2)
      res = Bitcoin::Account.get_address_type(address)
      res.should eq "p2sh"
    end

    it "Invalid sig countss" do
      account1 = Bitcoin::Account.generate_account(Bitcoin::Account::P2PKH)
      account2 = Bitcoin::Account.generate_account(Bitcoin::Account::P2PKH)
      account3 = Bitcoin::Account.generate_account(Bitcoin::Account::P2PKH)
      pub_keys = [
        account1.pubkey,
        account2.pubkey,
        account3.pubkey,
      ]
      expect_raises(Nodejs::JSSideException) do
        Bitcoin::Account.generate_multisig_address(pub_keys, 10)
      end
    end
  end
end
