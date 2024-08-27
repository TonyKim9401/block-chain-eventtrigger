pragma solidity ^0.6.0;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable{

    // ENUM 타입
    enum SupplyChainState{Created, Paid, Deliverd}

    // 아이템 구조
    struct S_Item {
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    // map 형식으로 저장
    mapping(uint => S_Item) public items;
    uint itemIndex;

    event SupplyChainStep(uint _itemIndex, uint _step, address _itemAddress);

    // 새 아이템 생성
    function createItem(string memory _identifier, uint _itemPrice) public onlyOwner(){
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;

        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(item));
        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable {
        // require, 조건이 성립해야함, 성립하지 않으면 ,뒤의 메세지를 실행함.
        require(items[_itemIndex]._itemPrice == msg.value, "Only full payments accepted");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the chain");

        items[_itemIndex]._state = SupplyChainState.Paid;

        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(items[_itemIndex]._item));
    }

    function triggerDelivery(uint _itemIndex) public onlyOwner(){
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the chain");

        items[_itemIndex]._state = SupplyChainState.Deliverd;

        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(items[_itemIndex]._item));
    }
}