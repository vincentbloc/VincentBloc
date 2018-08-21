pragma solidity ^0.4.18;

import "./ERC20/StandardToken.sol";
import "./ownership/Ownable.sol";

contract Vincent is StandardToken, Ownable {

  string public name = "Vincent";
  string public symbol = "VIC";
  uint8 public decimals = 18;

  function Vincent(uint256 _reserved, address[] owners, uint[] tokens) public {
      mint(msg.sender, _reserved);
      for (uint i=0; i< owners.length; i++) {
        require(tokens[i] != 0);
        mint(owners[i], tokens[i]);
      }
  }
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;


  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    Mint(_to, _amount);
    Transfer(address(0), _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() onlyOwner canMint public returns (bool) {
    mintingFinished = true;
    MintFinished();
    return true;
  }
}

