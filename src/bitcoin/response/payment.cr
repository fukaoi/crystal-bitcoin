require "json"

# JSONレスポンスをCrystal objectに変換
#
module Bitcoin::Response::Payment
  class Raw
    JSON.mapping(
      hash: String,
      version: Int64,
      inputs: Array(Input),
      outputs: Array(Output),
      nLockTime: Int64,
      changeScript: String,
      changeIndex: Int64,
    )
  end

  class Input
    JSON.mapping(
      prevTxId: String,
      outputIndex: Int64,
      sequenceNumber: Int64,
      script: String,
      scriptString: String,
      output: Output,
    )
  end

  class Output
    JSON.mapping(
      satoshis: Int64,
      script: String
    )
  end
end
