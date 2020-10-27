# Paymentに関係する処理を行うメインモジュール
#
# usage: README.md, spec/bitcoin/*_spec.crを参照
#
module Bitcoin::Payment
  extend self

  # シングルシグによるオフライン送金
	#
	# change: を指定しない場合送金元のアドレスが指定される
	# fee: 単位はBTC
  def send(
    from_account : NamedTuple(address: String, secret: String, pubkey: String),
    to : String,
    amount : String,
    utxos : Array(NamedTuple(txid: String, balance: String, index: Number)),
    change : String = "",
    fee : String = ""
  ) : String
    raise ValidationError.new("Invalid btc address: from") unless Account.is_address?(from_account[:address])
    raise ValidationError.new("Invalid btc address: to") unless Account.is_address?(to)
    raise ValidationError.new("Not found secret") if from_account[:secret].empty?
    raise ValidationError.new("Not found amount") if amount.empty?
    raise ValidationError.new("Not found utxos") if utxos.empty?
    server_url = Bitcoin.get_network[:server]
    raise ValidationError.new("No set server url") unless server_url

    params = Bitcoin.parse_server_param(server_url)
    network = Bitcoin.get_network[:network]
    code = Bitcoin.js_main(
      <<-CODE
      #{JsClass::Payment.export}
      const obj = new Payment(bitcore, '#{network}')
      const rawTx = obj.createTransaction(
         #{from_account},
        '#{to}',
         #{to_satoshi(amount).to_i64},
         #{utxos},
        '#{change}',
         #{to_satoshi(fee).to_i64},
      );

      const txid = await obj.send(
        rawTx,
        '#{params[:host]}',
        '#{params[:port]}',
        '#{params[:rpcuser]}',
        '#{params[:rpcpassword]}',
      )

      toCrystal(txid);
      CODE
    )

    Nodejs.eval(code).to_s
  end

  # マルチシグによるオフライン送金
  #
  # multisig_account = {
  #     address: マルチシグで生成したアドレス(P2SH),
  #     secrets: 2 of 3なら、2個の秘密鍵,
  #     pubkeyts: マルチシグアドレス生成時に作成した、全てのpubkey
  # }
  #
  # sig_count: 必要なシグの数(e.g: 2 of 3なら`2`)
  #
  # utxos = {
  #     txid: 送金元のunspent transacation id
  #     balance: 送金元のunspent transacation idのひもづく残高
  #     index: 送金元のunspent transacation idのvin
  # }
  #
  def send_by_multisig(
    multisig_account : NamedTuple(
      address: String, secrets: Array(String), pubkeys: Array(String)),
    sig_count : Int32,
    to : String,
    amount : String,
    utxos : Array(NamedTuple(txid: String, balance: String, index: Number)),
    change : String = "",
    fee : String = ""
  ) : String
    raise ValidationError.new("Invalid btc address: from") unless Account.is_address?(multisig_account[:address])
    raise ValidationError.new("Invalid btc address: to") unless Account.is_address?(to)
    raise ValidationError.new("Invalid sig_count") if sig_count < 1
    raise ValidationError.new("Not found secrets") if multisig_account[:secrets].empty?
    raise ValidationError.new("Not found pubkeys") if multisig_account[:pubkeys].empty?
    raise ValidationError.new("Not found amount") if amount.empty?
    raise ValidationError.new("Not found utxos") if utxos.empty?
    server_url = Bitcoin.get_network[:server]
    raise ValidationError.new("No set server url") unless server_url

    params = Bitcoin.parse_server_param(server_url)
    network = Bitcoin.get_network[:network]
    code = Bitcoin.js_main(
      <<-CODE
      #{JsClass::Payment.export}
      const obj = new Payment(bitcore, '#{network}')
      const rawTx = obj.createMultisigTransaction(
         #{multisig_account},
         #{sig_count},
        '#{to}',
         #{to_satoshi(amount).to_i64},
         #{utxos},
        '#{change}',
         #{to_satoshi(fee).to_i64},
      );

      const txid = await obj.send(
        rawTx,
        '#{params[:host]}',
        '#{params[:port]}',
        '#{params[:rpcuser]}',
        '#{params[:rpcpassword]}',
      )

      toCrystal(txid);
      CODE
    )

    Nodejs.eval(code).to_s
  end

  # btc to satoshi
  def to_satoshi(btc : String) : String
    code = Bitcoin.js_main(
      <<-CODE
      #{JsClass::Payment.export}
      const res = new Payment(bitcore).toSatoshi('#{btc}');
      toCrystal(res);
      CODE
    )

    Nodejs.eval(code).to_s
  end

  # satoshi to btc
  def to_btc(satoshi : String) : String
    code = Bitcoin.js_main(
      <<-CODE
      #{JsClass::Payment.export}
      const res = new Payment(bitcore).toBtc('#{satoshi}');
      toCrystal(res);
      CODE
    )

    Nodejs.eval(code).to_s
  end
end
