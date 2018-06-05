pragma solidity ^0.4.4;


import "./Destroyable.sol";
import "./Stoppable.sol";

contract Remittance is Stoppable, Destroyable {

  mapping(bytes32 => RemmitanceData) remData;

  struct RemmitanceData {
    address owner;
    address recipient;
    bytes32 unicPassw;
    uint finalDate;
    uint256 currDate;
  }

  RemmitanceData tempData;
  event LogNewRemittance(bool isCreated);
  event LogMoneySending(address to, uint amount);
  event LogReturnMoney(address to, uint amount);


  function setRemittanceData(uint daysAvailable, address receiver, bytes32 passwd) public payable {
    RemmitanceData tempRemitance;
    require(daysAvailable != 0);
    require(receiver != 0);
    tempRemitance.currDate = now;
    tempRemitance.owner = msg.sender;
    tempRemitance.finalDate = now + daysAvailable;
    tempRemitance.recipient = receiver;
    tempRemitance.unicPassw = passwd;
    remData[passwd] = tempRemitance;
    LogNewRemittance(true);
  }


  function claimRemittance(string firstPassw, string secondPassw) onlyIfRunning public returns (bool){
    tempData = remData[keccak256(firstPassw, secondPassw)];
    require(tempData.recipient != 0);
    emit LogMoneySending(tempData.recipient, this.balance);
    tempData.recipient.transfer(this.balance);
    return true;

  }


  function cashBack(string firstPassw, string secondPassw) onlyIfRunning public returns (bool success)
  {
    tempData = remData[keccak256(firstPassw, secondPassw)];
    require(tempData.owner != 0);
    require(tempData.finalDate < now);
    emit LogReturnMoney(tempData.owner, this.balance);
    tempData.owner.transfer(this.balance);
    return true;
  }
}