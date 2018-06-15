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


  event LogNewRemittanceData(address indexed sender, address recipien, bytes32 hashPass, uint deadline, uint balance);
  event LogClaimRemmitance(address indexed to, uint balance);
  event LogCashBack(address indexed to, uint balance);


  function setRemittanceData(uint daysAvailable, address receiver, bytes32 hashPass) public payable {

    require(daysAvailable != 0);
    require(receiver != 0);
    require( msg.value != 0);
    remData[hashPass] = RemmitanceData({
      owner: msg.sender,
      recipient: receiver,
      deadline: now + (daysAvailable * 86400),
      balance: msg.value
      });
    emit LogNewRemittanceData(msg.sender, receiver, hashPass,remData[hashPass].deadline, msg.value);
  }


  function claimRemittance(string firstPassw) onlyIfRunning public returns (bool){

    RemmitanceData storage tempData = remData[hashHelper(firstPassw, msg.sender)];
    require(tempData.recipient != 0);
    require(tempData.balance != 0);
    remData[hashHelper(firstPassw, msg.sender)].balance = 0;
    emit LogClaimRemmitance(tempData.recipient, tempData.balance);
    tempData.recipient.transfer(tempData.balance);
    return true;

  }

  function cashBack(string firstPassw) onlyIfRunning public returns (bool success)
  {
    RemmitanceData storage tempData = remData[hashHelper(firstPassw, msg.sender)];
    require(tempData.balance != 0);
    require(tempData.owner != 0);
    require(tempData.deadline < now);
    remData[hashHelper(firstPassw, msg.sender)].balance = 0;
    emit LogCashBack(tempData.owner, tempData.balance);
    tempData.owner.transfer(tempData.balance);
    return true;
  }

  function hashHelper(string passw, address userAddr) public pure returns (bytes32 hash) {
    return keccak256(userAddr, passw);
  }

}