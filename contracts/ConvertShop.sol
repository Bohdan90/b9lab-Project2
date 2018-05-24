pragma solidity ^0.4.4;

contract ConvertShop {
    uint internal tokensAmount;
    mapping(address => uint) userTokenBalances;

    event LogConverted(uint);
    event LogClearened(uint);
    event LogSended(address, uint);

    function convert(uint amount) internal returns (bool)
    {
        LogConverted(amount);
        tokensAmount = amount + tokensAmount;

        return true;
    }

    function getCurrTokensAddr(address addr) internal returns (uint)
    {
        return userTokenBalances[addr];
    }

    function getTokens() returns (uint)
    {
        return tokensAmount;
    }

    function clearTokenAmount() internal returns (bool)
    {
        LogClearened(tokensAmount);
        tokensAmount = 0;
        return true;
    }

    function sendTokensTo(address addr) internal returns (bool)
    {
        LogSended(addr, tokensAmount);
        userTokenBalances[addr] = tokensAmount;
        tokensAmount = 0;
        return true;
    }

}