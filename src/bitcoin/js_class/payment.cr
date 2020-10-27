# bitcore - libのアカウントに関係するJSコードを管理している
# サブセットモジュール
module Bitcoin::JsClass::Payment
  extend self

  # Stringで定義したJSコードを返す
  def export : String
    <<-CODE
    // rawtxのブロードキャストに使用
    const Client = require('bitcoin-core');

    #{Account.export}

    class Payment {
      constructor(bitcore, network = "") {
        this.bitcore = bitcore;
        this.network = network;
        this.a = new Account(bitcore);
      }

      // シングルシグ用
      createTransaction(from_account, to, amount, unspents, change = '', fee = '') {
        let script = "";
        // P2SHとP2PKHでscriptパラメーターが異なる
        if (this.a.getAddressType(from_account.address) == "p2pkh") {
          script = this.bitcore.Script.buildPublicKeyHashOut(from_account.address).toHex();
        } else {
          // P2SHでpubkeyが必要
          const accountObj = new this.bitcore.Address(
            [from_account.pubkey],
            1,
            this.network
          );
          script = new this.bitcore.Script(accountObj).toHex();
        }

        // change addressがemptyならfrom addressを指定する
        if (change == '') change = from_account.address;

        const tx = new this.bitcore.Transaction()
          .to(to, amount)
          .change(change);

        // feeパラメーターを設定した場合
        if (fee != '') tx.fee(fee);

        // inputの作成
        const input = unspents.map((unspent) => {
          return {
            txId: unspent.txid,
            outputIndex: unspent.index,
            address: from_account.address,
            script: script,
            amount: unspent.balance,
          }
        });

        // P2SHとP2PKHでfromパラメーターが異なる
        if (this.a.getAddressType(from_account.address) == "p2pkh") {
          tx.from(input);
        } else {
          tx.from(input, [from_account.pubkey], 1);
        }

        tx.sign(from_account.secret);
        return tx.serialize();
      }

      // マルチシグ用
      createMultisigTransaction(
        multisigAccount,
        sigCount,
        to,
        amount,
        unspents,
        change = '',
        fee = ''
      ) {

        const accountObj = new this.bitcore.Address(
          multisigAccount.pubkeys, 
          sigCount
        );
        const script = new this.bitcore.Script(accountObj).toHex();

        // change addressがemptyならfrom addressを指定する
        if (change == '') change = multisigAccount.address;

        // inputの作成
        const input = unspents.map((unspent) => {
          return {
            txId: unspent.txid,
            outputIndex: unspent.index,
            address: multisigAccount.address,
            script: script,
            amount: unspent.balance,
          }
        });

        const tx = new this.bitcore.Transaction()
          .from(input, multisigAccount.pubkeys, sigCount)
          .to(to, amount)
          .change(change);

        // feeパラメーターを設定した場合
        if (fee != '') tx.fee(fee);

        tx.sign(multisigAccount.secrets);
        return tx.serialize();
      }

      async send(rawTx, host, port, username, password) {
        const client = new Client({
          host: host,
          port: port,
          username: username,
          password: password,
        });

        return await client.sendRawTransaction(rawTx);
      }

      toSatoshi(btc) {
        return this.bitcore.Unit.fromBTC(btc).toSatoshis();
      }

      toBtc(satoshi) {
        return this.bitcore.Unit.fromSatoshis(satoshi).toBTC();
      }
    }
  CODE
  end
end
