pragma solidity ^0.4.4;

import "./Ownable.sol";
import "./ConvertShop.sol";
import "./Destroyable.sol";

contract Remittance is Ownable, ConvertShop, Destroyable, onlyIfRunning {

    address private owner;
    uint private finalDate;
    uint256 private currDate;
    bytes32 private passwd1 = keccak256('Qwerty1');
    bytes32 private passwd2 = keccak256('Qwerty2');


    event LogReturnMoney(address, uint);

    function Remittance(uint daysAvailable)
    public
    {
        currDate = now;
        owner = msg.sender;
        finalDate = currDate + daysAvailable;
    }

    modifier checkFinalDate()
    {
        require(finalDate < now);
        _;
    }

    function getCurrentSubval() public returns (uint){
        return getTokens();

    }

    function convertMoney()
    public
    payable
    returns (bool success){
        require(msg.value > 0);
        convert(msg.value);
        return true;
    }

    function reckoning(string firstPassw, string secondPassw) onlyIfRunning public returns (bool){
        if (passwd1 == keccak256(firstPassw) && passwd2 == keccak256(secondPassw)) {
            sendTokensTo(msg.sender);
            return true;
        } else {
            return false;
        }
    }

    function getTokensBalance() returns (uint){
        return getCurrTokensAddr(msg.sender);
    }

    function cashBack() checkFinalDate onlyIfRunning public payable returns (bool success)
    {
        LogReturnMoney(msg.sender, this.balance);
        msg.sender.transfer(this.balance);
        clearTokenAmount();
        return true;
    }
}