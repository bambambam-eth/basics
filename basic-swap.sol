pragma solidity ^0.7.0;

contract TokenExchange {
    mapping(address => uint256) public balances;
    address payable public owner;
    uint256 public ethToTokenRate;
    ERC20 public token;

    constructor(address _tokenAddress, uint256 _ethToTokenRate) public {
        owner = msg.sender;
        token = ERC20(_tokenAddress);
        ethToTokenRate = _ethToTokenRate;
    }

    function exchangeETHForToken() public payable {
        require(msg.value > 0, "You must send a positive amount of ETH to exchange.");

        uint256 tokenAmount = msg.value.mul(ethToTokenRate);
        require(token.transfer(msg.sender, tokenAmount), "Token transfer failed.");

        balances[msg.sender] = balances[msg.sender].add(tokenAmount);
    }

    function exchangeTokenForETH(uint256 _tokenAmount) public {
        require(_tokenAmount > 0, "You must exchange a positive amount of tokens.");
        require(token.transferFrom(msg.sender, address(this), _tokenAmount), "Token transfer failed.");

        uint256 ethAmount = _tokenAmount.div(ethToTokenRate);
        msg.sender.transfer(ethAmount);

        balances[msg.sender] = balances[msg.sender].sub(_tokenAmount);
    }

    function getBalance(address _address) public view returns (uint256) {
        return balances[_address];
    }

    function setETHToTokenRate(uint256 _ethToTokenRate) public {
        require(msg.sender == owner, "Only owner can set exchange rate.");
        ethToTokenRate = _ethToTokenRate;
    }

    function getETHToTokenRate() public view returns (uint256) {
        return ethToTokenRate;
    }
}
