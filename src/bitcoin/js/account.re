module Account = {
  [@bs.deriving abstract]
  type accountConvertJs = {
    address: string,
    privateKey: string,
  };

  [@bs.module] external bitcore: Js.t('a) = "bitcore-lib";
  
  let create = (): accountConvertJs => {
    let internal: (Js.t('a)) => Js.t('b) = [%raw
      (obj) => {|return new obj.PrivateKey()|}
    ];
    let privateKey = internal(bitcore);
    let address = privateKey##toAddress();
    accountConvertJs(~address=address##toString(), ~privateKey=privateKey##toString());
  };
};
