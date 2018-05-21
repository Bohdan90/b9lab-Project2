pragma solidity ^0.4.4;

contract ConvertShop{
    uint internal tokensAmount;
    mapping (address => uint) userTokenBalances;

    function convert(uint amount)internal returns (bool)
    {
        tokensAmount = amount + tokensAmount;
        return true;
    }

    function getCurrTokensAddr(address addr)internal returns (uint)
    {
        return userTokenBalances[addr];
    }

    function getTokens() returns (uint)
    {
        return tokensAmount;
    }

    function clearTokenAmount()internal returns (bool)
    {
        tokensAmount = 0;
        return true;
    }

    function sendTokensTo(address addr)internal returns (bool)
    {
        userTokenBalances[addr]=tokensAmount;
        tokensAmount =0;
        return true;
    }

}