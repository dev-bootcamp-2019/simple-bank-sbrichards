pragma solidity ^0.5.0;

contract SimpleBank {
    mapping (address => uint) private balances;
    mapping (address => bool) public enrolled;
    address owner;
    
    event LogEnrolled(address indexed accountAddress);
    event LogDepositMade(address indexed accountAddress, uint amount);
    event LogWithdrawal(address indexed accountAddress, uint withdrawAmount, uint newBalance);


    constructor() public {
        owner = msg.sender;
    }

    /// @notice Get balance
    /// @return The balance of the user
    function balance() public view returns (uint) {
        require(enrolled[msg.sender], "Address is not enrolled.");
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool){
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return true;
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
        require(enrolled[msg.sender], "Address is not enrolled.");
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    // Emit the appropriate event    
    function withdraw(uint withdrawAmount) public returns (uint) {
        require(enrolled[msg.sender], "Address is not enrolled.");
        require(balances[msg.sender] >= withdrawAmount, "Insufficient funds.");
        balances[msg.sender] -= withdrawAmount;
        msg.sender.transfer(withdrawAmount);
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        return balances[msg.sender];
    }

    // Fallback function
    function() external {
        revert();
    }
}
