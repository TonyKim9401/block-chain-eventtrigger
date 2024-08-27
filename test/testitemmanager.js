// every test is always executed as a new smart contract
const ItemManager = artifacts.require("./ItemManager.sol");

contract("ItemManager", (accounts) => {
  it("... should be able to add an Item", async function () {
    const itemManagerInstance = await ItemManager.deployed();
    const itemName = "test1";
    const itemPrice = 500;

    const result = await itemManagerInstance.createItem(itemName, itemPrice, {
      from: accounts[0],
    });
    console.log(result.logs[0].args);
    assert.equal(result.logs[0].args._itemIndex, 0, "It's not the first item");

    const item = await itemManagerInstance.items(0);
    assert.equal(item._identifier, itemName, "The identifier was different");
  });
});
