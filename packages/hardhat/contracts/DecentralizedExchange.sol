// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract DecentralizedExchange {
    using SafeERC20 for IERC20;

    mapping(address => mapping(address => uint256)) public balances;

    event Deposit(address indexed token, address indexed user, uint256 amount);
    event Withdraw(address indexed token, address indexed user, uint256 amount);
    event Trade(address indexed tokenGive, uint256 amountGive, address indexed tokenGet, uint256 amountGet);

    // Deposits tokens into the exchange
    function deposit(address _token, uint256 _amount) external {
        IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
        balances[_token][msg.sender] += _amount;
        emit Deposit(_token, msg.sender, _amount);
    }

    // Withdraws tokens from the exchange
    function withdraw(address _token, uint256 _amount) external {
        require(balances[_token][msg.sender] >= _amount, "Insufficient balance");
        balances[_token][msg.sender] -= _amount;
        IERC20(_token).safeTransfer(msg.sender, _amount);
        emit Withdraw(_token, msg.sender, _amount);
    }

    // Trades tokens on the exchange
    function trade(address _tokenGive, uint256 _amountGive, address _tokenGet, uint256 _amountGet) external {
        require(balances[_tokenGive][msg.sender] >= _amountGive, "Insufficient balance to trade");
        balances[_tokenGive][msg.sender] -= _amountGive;
        balances[_tokenGet][msg.sender] += _amountGet;
        emit Trade(_tokenGive, _amountGive, _tokenGet, _amountGet);
    }
}