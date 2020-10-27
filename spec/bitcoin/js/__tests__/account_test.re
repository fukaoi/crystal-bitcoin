open Jest;
open Account;

/* describe("beforeAll", () =>  */
  /* "https://ropsten.infura.io/v3/1835809e0e6a4de38eaf1f7afb51e0ec" */
  /* |> Util.set */
/* ); */

describe("create", () => {
  open Expect;

  test("address", () => {
    let res = Account.create();
    Js.log(res);
    expect(String.length(Account.addressGet(res))) |> toBe(34);
  });

  test("privateKey", () => {
    let res = Account.create();
    expect(String.length(Account.privateKeyGet(res))) |> toBe(64);
  });
});

