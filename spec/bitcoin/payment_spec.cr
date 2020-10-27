require "../bitcoin_spec"
require "colorize"

describe Bitcoin::Payment do
  Spec.before_each do
    Bitcoin.set_network(Bitcoin::Network::Regtest)
  end

  describe "send" do
    describe "P2PKH #{wallet = "send_p2pkh"}" do
      it "Send BTC, no set:[fee, change]" do
        amount = "2.99"
        from_p2pkh = Helper.from_p2pkh(wallet)
        to_address = Helper.to(wallet)[:address]
        vout = Helper.send_to_from(from_p2pkh[:address], 3)
        Helper.do_mining(1)

        res = Bitcoin::Payment.send(
          from_account: from_p2pkh,
          to: to_address,
          amount: amount,
          utxos: [vout.not_nil!],
        )
        puts "[txid]\n#{res}".colorize(:blue)
        res.should_not be_nil
        Helper.do_mining(1)
        balance = Helper.get_balance(wallet, to_address)
        balance.should eq amount
      end

      it "Send BTC, no set[change]" do
        amount = "2.99"
        from_p2pkh = Helper.from_p2pkh(wallet)
        to_address = Helper.to(wallet)[:address]
        vout = Helper.send_to_from(from_p2pkh[:address], 3)
        Helper.do_mining(1)

        res = Bitcoin::Payment.send(
          from_account: from_p2pkh,
          to: to_address,
          amount: amount,
          utxos: [vout.not_nil!],
          fee: "0.01"
        )
        puts "[txid]\n#{res}".colorize(:blue)
        res.should_not be_nil
        Helper.do_mining(1)
        balance = Helper.get_balance(wallet, to_address)
        balance.should eq amount
      end

      it "Send BTC set fee, change" do
        amount = "2.0"
        fee = "0.01"
        change = "0.99"
        from_p2pkh = Helper.from_p2pkh(wallet)
        to_address = Helper.to(wallet)[:address]
        change_address = Helper.change(wallet)[:address]
        vout = Helper.send_to_from(from_p2pkh[:address], 3)
        Helper.do_mining(1)

        res = Bitcoin::Payment.send(
          from_account: from_p2pkh,
          to: to_address,
          amount: amount,
          utxos: [vout.not_nil!],
          fee: fee,
          change: change_address
        )
        puts "[txid]\n#{res}".colorize(:blue)
        res.should_not be_nil
        Helper.do_mining(1)
        balance = Helper.get_balance(wallet, to_address)
        balance.should eq amount
        change_balance = Helper.get_balance(wallet, change_address)
        change_balance.should eq change
      end

      it "Send BTC set fee, change with multiple utxo" do
        amount = "8.0"
        fee = "0.01"
        change = "0.99"
        from_p2pkh = Helper.from_p2pkh(wallet)
        to_address = Helper.to(wallet)[:address]
        change_address = Helper.change(wallet)[:address]
        vout1 = Helper.send_to_from(from_p2pkh[:address], 3)
        vout2 = Helper.send_to_from(from_p2pkh[:address], 3)
        vout3 = Helper.send_to_from(from_p2pkh[:address], 3)
        Helper.do_mining(1)

        res = Bitcoin::Payment.send(
          from_account: from_p2pkh,
          to: to_address,
          amount: amount,
          utxos: [vout1.not_nil!, vout2.not_nil!, vout3.not_nil!],
          fee: fee,
          change: change_address
        )
        puts "[txid]\n#{res}".colorize(:blue)
        res.should_not be_nil
        Helper.do_mining(1)
        balance = Helper.get_balance(wallet, to_address)
        balance.should eq amount
        change_balance = Helper.get_balance(wallet, change_address)
        change_balance.should eq change
      end
    end

    describe "P2SH #{wallet = "send_p2sh"}" do
      it "Send BTC, no set:[fee, change]" do
        amount = "2.99"
        from_p2sh = Helper.from_p2sh(wallet)
        to_address = Helper.to(wallet)[:address]
        vout = Helper.send_to_from(from_p2sh[:address], 3)
        Helper.do_mining(1)

        res = Bitcoin::Payment.send(
          from_account: from_p2sh,
          to: to_address,
          amount: amount,
          utxos: [vout.not_nil!],
        )
        puts "[txid]\n#{res}".colorize(:blue)
        res.should_not be_nil
        Helper.do_mining(1)
        balance = Helper.get_balance(wallet, to_address)
        balance.should eq amount
      end

      it "Send BTC, no set[change]" do
        amount = "2.99"
        from_p2sh = Helper.from_p2sh(wallet)
        to_address = Helper.to(wallet)[:address]
        vout = Helper.send_to_from(from_p2sh[:address], 3)
        Helper.do_mining(1)

        res = Bitcoin::Payment.send(
          from_account: from_p2sh,
          to: to_address,
          amount: amount,
          utxos: [vout.not_nil!],
          fee: "0.01"
        )
        puts "[txid]\n#{res}".colorize(:blue)
        res.should_not be_nil
        Helper.do_mining(1)
        balance = Helper.get_balance(wallet, to_address)
        balance.should eq amount
      end

      it "Send BTC set fee, change" do
        amount = "2.0"
        fee = "0.01"
        change = "0.99"
        from_p2sh = Helper.from_p2sh(wallet)
        to_address = Helper.to(wallet)[:address]
        change_address = Helper.change(wallet)[:address]
        vout = Helper.send_to_from(from_p2sh[:address], 3)
        Helper.do_mining(1)

        res = Bitcoin::Payment.send(
          from_account: from_p2sh,
          to: to_address,
          amount: amount,
          utxos: [vout.not_nil!],
          fee: fee,
          change: change_address
        )
        puts "[txid]\n#{res}".colorize(:blue)
        res.should_not be_nil
        Helper.do_mining(1)
        balance = Helper.get_balance(wallet, to_address)
        balance.should eq amount
        change_balance = Helper.get_balance(wallet, change_address)
        change_balance.should eq change
      end

      it "Send BTC set fee, change with multiple utxo" do
        amount = "8.0"
        fee = "0.01"
        change = "0.99"
        from_p2sh = Helper.from_p2sh(wallet)
        to_address = Helper.to(wallet)[:address]
        change_address = Helper.change(wallet)[:address]
        vout1 = Helper.send_to_from(from_p2sh[:address], 3)
        vout2 = Helper.send_to_from(from_p2sh[:address], 3)
        vout3 = Helper.send_to_from(from_p2sh[:address], 3)
        Helper.do_mining(1)

        res = Bitcoin::Payment.send(
          from_account: from_p2sh,
          to: to_address,
          amount: amount,
          utxos: [vout1.not_nil!, vout2.not_nil!, vout3.not_nil!],
          fee: fee,
          change: change_address
        )
        puts "[txid]\n#{res}".colorize(:blue)
        res.should_not be_nil
        Helper.do_mining(1)
        balance = Helper.get_balance(wallet, to_address)
        balance.should eq amount
        change_balance = Helper.get_balance(wallet, change_address)
        change_balance.should eq change
      end
    end
  end

  describe "send_by_multisig #{wallet = "multisig"}" do
    it "Success send 3 of 3, no set:[fee, change]" do
      amount = "9.99"
      sig_count = 3
      from_multisig = Helper.from_multisig(wallet, 3, sig_count)
      to_address = Helper.to(wallet)[:address]
      vout = Helper.send_to_from(from_multisig[:address], 10)

      Helper.do_mining(1)

      res = Bitcoin::Payment.send_by_multisig(
        multisig_account: from_multisig,
        sig_count: sig_count,
        to: to_address,
        amount: amount,
        utxos: [vout.not_nil!],
      )
      puts "[multisid address]\n#{from_multisig[:address]}".colorize(:green)
      puts "[txid]\n#{res}".colorize(:blue)
      res.should_not be_nil

      Helper.do_mining(1)

      balance = Helper.get_balance(wallet, to_address)
      balance.should eq amount
    end

    it "Success send 2 of 3, no set:[fee, change]" do
      amount = "9.99"
      sig_count = 2
      from_multisig = Helper.from_multisig(wallet, 3, sig_count)
      to_address = Helper.to(wallet)[:address]
      vout = Helper.send_to_from(from_multisig[:address], 10)

      Helper.do_mining(1)

      res = Bitcoin::Payment.send_by_multisig(
        multisig_account: from_multisig,
        sig_count: sig_count,
        to: to_address,
        amount: amount,
        utxos: [vout.not_nil!],
      )
      puts "[multisid address]\n#{from_multisig[:address]}".colorize(:green)
      puts "[txid]\n#{res}".colorize(:blue)
      res.should_not be_nil

      Helper.do_mining(1)

      balance = Helper.get_balance(wallet, to_address)
      balance.should eq amount
    end
  end

  describe "to_satoshi" do
    res = Bitcoin::Payment.to_satoshi("12.5")
    res.should eq "1250000000"
  end

  describe "to_btc" do
    res = Bitcoin::Payment.to_btc("1250000000")
    res.should eq "12.5"
  end
end
