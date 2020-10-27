require "http/client"
require "colorize"

# Accountに関係する処理を行うメインモジュール
#
# usage: README.md, spec/ethereum/*_spec.crを参照
#
module Bitcoin::Account
  extend self

  P2PKH = "pubkeyhash"
  P2SH  = "scripthash"

  # address, secrectを自動生成する
  def generate_account(address_type : String = P2SH) : Response::Account
    network = Bitcoin.get_network[:network]
    code = Bitcoin.js_main(
      <<-CODE
      #{JsClass::Account.export}
      const res = new Account(bitcore, "#{network}")
      .create("#{address_type}");
      toCrystal(res);
      CODE
    )

    res = Nodejs.eval(code).to_json
    Response::Account.from_json(res)
  end

  # マルチシグアドレスの生成
  # P2SHアドレスタイプが指定される
  def generate_multisig_address(pub_keys : Array(String), sig_count : Int32) : String
    network = Bitcoin.get_network[:network]
    code = Bitcoin.js_main(
      <<-CODE
      #{JsClass::Account.export}
      const res = new Account(bitcore, "#{network}")
      .createMultiSigAddress(#{pub_keys}, #{sig_count});
      toCrystal(res);
      CODE
    )

    Nodejs.eval(code).to_s
  end

  # 与えられた文字列がBitcoinのアドレス形式に
  # マッチしているかチェック
  def is_address?(address : String) : Bool
    code = Bitcoin.js_main(
      <<-CODE
      #{JsClass::Account.export}
      const res = new Account(bitcore)
      .isAddress("#{address}");
      toCrystal(res);
      CODE
    )
    Nodejs.eval(code).to_json == "true" ? true : false
  end

  # ビットコインアドレスタイプを取得
  # e.g: p2sh, p2pkh
  def get_address_type(address : String) : String
    code = Bitcoin.js_main(
      <<-CODE
      #{JsClass::Account.export}
      const res = new Account(bitcore)
      .getAddressType("#{address}");
      toCrystal(res);
      CODE
    )
    Nodejs.eval(code).to_s
  end

  # Network enumよりtestnetの判断
  private def is_testnet?
    testnet_str = Network::Testnet.to_s.downcase
    Bitcoin.get_network[:network] == testnet_str
  end
end
