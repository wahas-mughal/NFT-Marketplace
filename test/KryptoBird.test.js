const { assert } = require("chai");

//bring in the artifacts
const KryptoBird = artifacts.require("./KryptoBird");

// check for chai
require("chai")
  .use(require("chai-as-promised"))
  .should();

contract("KryptoBird", (accounts) => {
  let contract;
  before(async () => {
    contract = await KryptoBird.deployed();
  });

  // test container
  describe("deployment", async () => {
    //case 1: address should be valid
    it("deployed successfully!", async () => {
      const address = contract.address;
      assert.notEqual(address, "");
      assert.notEqual(address, null);
      assert.notEqual(address, undefined);
      assert.notEqual(address, 0x0);
    });

    //case 1: name and symbol should match with the contract
    it("name and symbol matches with contract successfully!", async () => {
      const name = await contract.name();
      const symbol = await contract.symbol();
      assert.equal(name, "KryptoBirdz");
      assert.equal(symbol, "KBIRDZ");
    });

    describe("minting", async () => {
      it("New token is created!", async () => {
        const result = await contract.mint("http...1");
        const totalSupply = await contract.totalSupply();

        //for succcess
        assert.equal(totalSupply, 1);
        const event = result.logs[0].args;
        assert.equal(event._from, "0x0000000000000000000000000000000000000000");
        assert.equal(event._to, accounts[0], "To is msg.sender");

        //for failure
        await contract.mint("http...1").should.be.rejected;
      });
    });

    describe("indexing", async () => {
      it("lists of KryptoBirdz", async () => {
        await contract.mint("http...2");
        await contract.mint("http...3");
        await contract.mint("http...4");
        const totalSupply = await contract.totalSupply();

        //loop through the list of KBIRDZ grab one
        let result = [];
        let KryptoBird;

        for (let i = 1; i <= totalSupply; i++) {
          KryptoBird = await contract.kryptoBirds(i - 1);
          result.push(KryptoBird);
        }

        //assert that result array is equal to the KBIRDS array
        let expected = ["http...1", "http...2", "http...3", "http...4"];
        assert.equal(result.join(","), expected.join(","));
      });
    });
  });
});
