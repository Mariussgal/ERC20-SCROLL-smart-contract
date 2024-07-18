/*
 

             ________________________________
           =(__    ___      ___     ___ __ __)=
             |                               |
             |                               |
             |                       _ _     |
             |                      | | |    |
             |    ___  ___ _ __ ___ | | |    |
             |   / __|/ __| '__/ _ \| | |    |
             |   \__ \ (__| | | (_) | | |    |
             |   |___/\___|_|  \___/|_|_|    |             
             |                               |
             |                               |
             |                               |
             |                               |
             |                               |
             | https://github.com/Mariussgal |
             |                               |
             |                               |
             |                               |
             |                               |
             |__    ___   __    ___  ___  ___|
           =(_________________________________)=

                       


*/


// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

interface ERC20 {
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address _owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IUniswapV2Factory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

interface IUniswapV2Router {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
}

abstract contract Ownable {
    address internal _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = msg.sender;
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "!owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "new is 0");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract MGS is ERC20, Ownable {
    string private _name = "mariussgalSCROLL";
    string private _symbol = "MGS";
    uint8 constant _decimals = 18;
    uint256 _totalSupply = 100000 * 10 ** _decimals;

    mapping(address => mapping(address => uint256)) _allowances;
    mapping(address => uint256) _balances;

    IUniswapV2Router router =
        IUniswapV2Router(0x9B3336186a38E1b6c21955d112dbb0343Ee061eE);
    address public pair;

    uint256 public _maxWalletSize = (_totalSupply * 4) / 100;
    mapping(address => bool) maxWalletExempt;

    bool public canTrade = false;

    constructor() Ownable() {
        pair = IUniswapV2Factory(router.factory()).createPair(
            router.WETH(),
            address(this)
        );
        maxWalletExempt[msg.sender] = true;
        maxWalletExempt[address(this)] = true;
        maxWalletExempt[pair] = true;
        _balances[msg.sender] = (_totalSupply * 100) / 100;
        emit Transfer(address(0), msg.sender, (_totalSupply * 100) / 100);
    }

    receive() external payable {}

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function decimals() external pure override returns (uint8) {
        return _decimals;
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function allowance(
        address holder,
        address spender
    ) external view override returns (uint256) {
        return _allowances[holder][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transfer(
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, type(uint256).max);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        if (_allowances[sender][msg.sender] != type(uint256).max) {
            _allowances[sender][msg.sender] =
                _allowances[sender][msg.sender] -
                amount;
        }
        return _transferFrom(sender, recipient, amount);
    }

    function _transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        require(canTrade || maxWalletExempt[recipient], "not owner");

        require(
            (_balances[recipient] + amount <= _maxWalletSize ||
                maxWalletExempt[recipient] ||
                sender == owner() ||
                recipient == pair),
            "max wallet hit"
        );

        _balances[sender] = _balances[sender] - amount;
        _balances[recipient] = _balances[recipient] + (amount);

        emit Transfer(sender, recipient, amount);
        return true;
    }

    function setMaxWalletExemptOnWallet(
        address holder,
        bool exempt
    ) external onlyOwner {
        maxWalletExempt[holder] = exempt;
    }

    function enableTrading(bool _canTrade) external onlyOwner {
        canTrade = _canTrade;
    }

    function removeWalletLimit() external onlyOwner {
        _maxWalletSize = type(uint256).max;
    }

    function shouldTakeFee(address sender) internal view returns (bool) {
        return !maxWalletExempt[sender];
    }
}