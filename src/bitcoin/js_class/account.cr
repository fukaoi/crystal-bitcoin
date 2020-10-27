# bitcore-libのアカウントに関係するJSコードを管理している
# サブセットモジュール
module Bitcoin::JsClass::Account
  extend self

  # Stringで定義したJSコードを返す
  def export : String
    <<-CODE
    const validate = require('bitcoin-address-validation');

    class Account {
      constructor(bitcore, network = "") {
        this.bitcore = bitcore;
        this.network = network; 
      }

      // アカウントの生成
      create(address_type) {
        const privateKey = this.bitcore.PrivateKey();

        // P2PKHアドレスの生成
        const addressObj = privateKey.toAddress(this.network);
        let account = {
          address: addressObj.toString(),
          secret: privateKey.toString(),
          pubkey: privateKey.toPublicKey().toString(),
          type: addressObj.type,
        }

        // P2SHアドレスの生成
        if (address_type == this.bitcore.Address.PayToScriptHash) {
          const p2shAddressObj = new this.bitcore.Address(
            [account.pubkey], 
            1, 
            this.network
          );
          account.address = p2shAddressObj.toString();
          account.type = p2shAddressObj.type;
        }
        return account;
      }

      // マルチシグアドレスの作成
      createMultiSigAddress(publicKeys, sigCount) {
        return new this.bitcore.Address(
          publicKeys,
          sigCount,
          this.network
        ).toString();
      }

      // アドレスの有効性確認
      isAddress(address) {
        if (validate(address) != false) {
          return true;
        }
        return false;
      }

      // P2SH, P2PKHあどのアドレスタイプを返す
      getAddressType(address) {
        return validate(address).type;
      }
    }
    CODE
  end
end
