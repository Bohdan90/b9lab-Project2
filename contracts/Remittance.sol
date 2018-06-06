pragma solidity ^0.4.4;


import "./Destroyable.sol";
import "./Stoppable.sol";

contract Remittance is Stoppable, Destroyable {

  mapping(bytes32 => RemmitanceData) remData;

  struct RemmitanceData {
    address owner;
    address recipient;
    uint deadline;
    uint balance;
  }

  RemmitanceData tempData;

  event LogNewRemittanceData(address sender, address recipien, bytes32 hashPass, uint deadline, uint balance);
  event LogClaimRemmitance(address to, uint balance);
  event LogCashBack(address to, uint balance);


  function setRemittanceData(uint daysAvailable, address receiver, bytes32 hashPass) public payable {
    RemmitanceData tempRemitance;
    require(daysAvailable != 0);
    require(receiver != 0);
    tempRemitance.owner = msg.sender;
    tempRemitance.deadline = now + (daysAvailable * 86400);
    tempRemitance.recipient = receiver;
    tempRemitance.balance = msg.value;
    remData[hashPass] = tempRemitance;
    emit LogNewRemittanceData(tempRemitance.owner, tempRemitance.recipient, hashPass,tempRemitance.deadline, tempRemitance.balance);
  }


  function claimRemittance(string firstPassw) onlyIfRunning public returns (bool){
    tempData = remData[keccak256(msg.sender, firstPassw)];
    require(tempData.recipient != 0);
    require(tempData.balance != 0);
    remData[keccak256(msg.sender, firstPassw)].balance = 0;
    emit LogClaimRemmitance(tempData.recipient, tempData.balance);
    tempData.recipient.transfer(tempData.balance);
    return true;

  }

  function cashBack(string firstPassw) onlyIfRunning public returns (bool success)
  {
    tempData = remData[keccak256(msg.sender, firstPassw)];
    require(tempData.balance != 0);
    require(tempData.owner != 0);
    require(tempData.deadline < now);
    remData[keccak256(msg.sender, firstPassw)].balance = 0;
    emit LogCashBack(tempData.owner, tempData.balance);
    tempData.owner.transfer(tempData.balance);
    return true;
  }

  function hashHelper(string passw) public pure returns (bytes32 hash) {
    return keccak256(msg.sender, passw);
  }

}