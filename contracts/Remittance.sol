pragma solidity ^0.4.4;


import "./Destroyable.sol";
import "./Stoppable.sol";

contract Remittance is Stoppable, Destroyable {

  mapping(bytes32 => RemmitanceData) remData;

  struct RemmitanceData {
    address owner;
    address recipient;
    uint deadline;
  }

  RemmitanceData tempData;
  event LogNewRemittanceData(uint deadline,address receiver,bytes32 hashedPass);
  event LogClaimRemmitance(address to, uint balance);
  event LogCashBack(address to, uint balance);


  function setRemittanceData(uint daysAvailable, address receiver, bytes32 hashPass) public payable {
    RemmitanceData tempRemitance;
    require(daysAvailable != 0);
    require(receiver != 0);
    tempRemitance.owner = msg.sender;
    tempRemitance.deadline = now + (daysAvailable *86400);
    tempRemitance.recipient = receiver;
    remData[hashPass] = tempRemitance;
    LogNewRemittanceData(tempRemitance.deadline,tempRemitance.recipient, hashPass);
  }


  function claimRemittance(string firstPassw) onlyIfRunning public returns (bool){
    tempData = remData[keccak256(msg.sender,firstPassw)];
    require(tempData.recipient != 0);
    emit LogClaimRemmitance(tempData.recipient, this.balance);
    tempData.recipient.transfer(this.balance);
    return true;

  }


  function cashBack(string firstPassw) onlyIfRunning public returns (bool success)
  {
    tempData = remData[keccak256(msg.sender,firstPassw)];
    require(tempData.owner != 0);
    require(tempData.deadline < now);
    emit LogCashBack(tempData.owner, this.balance);
    tempData.owner.transfer(this.balance);
    return true;
  }

  function hashHelper(address addr, string passw) public pure returns(bytes32 hash) {
    return keccak256(addr,passw);
  }

}