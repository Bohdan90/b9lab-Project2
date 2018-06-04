pragma solidity ^0.4.4;



import "./Destroyable.sol";
import "./Stoppable.sol";

contract Remittance is Stoppable, Destroyable {

  address private owner;
  address private recipient;

  uint private finalDate;
  uint256 private currDate;
  bytes32 private unicPassw;

  event LogMoneySending(address to, uint amount);
  event LogReturnMoney(address to, uint amount);

  constructor(uint daysAvailable,address receiver,  bytes32 passwd)
  public payable
  {
    require(daysAvailable != 0);
    require(receiver != 0);
    currDate = now;
    owner = msg.sender;
    finalDate = currDate + daysAvailable;
    recipient = receiver;
    //Probably i should  do something like: unicPassw = keccak256("pass1", "pass2").
    unicPassw = passwd;

  }

  modifier checkFinalDate()
  {
    require(finalDate < now);
    _;
  }


  function claimRemittance(string firstPassw, string secondPassw) onlyIfRunning public returns (bool){
    if (keccak256(firstPassw, secondPassw) == unicPassw) {
      emit LogMoneySending(msg.sender, this.balance);
      recipient.transfer(this.balance);
      return true;
    } else {
      return false;
    }
  }


  function cashBack() checkFinalDate onlyIfRunning public returns (bool success)
  {
    require(owner == msg.sender);
    emit LogReturnMoney(msg.sender, this.balance);
    msg.sender.transfer(this.balance);
    return true;
  }
}