pragma solidity ^0.4.18;
import "../../math/SafeMath.sol";
import "../Crowdsale.sol";


/**
 * @title TimedCrowdsale
 * @dev Crowdsale accepting contributions only within a time frame.
 */
contract TimedCrowdsale is Crowdsale {
  using SafeMath for uint256;

  uint256 public openingTime;
  uint256 public firstTimeEnd;
  uint256 public secondTimeEnd;
  uint256 public thirdTimeEnd;
  uint256 public closingTime;
  /**
   * @dev Reverts if not in crowdsale time range.
   */
  modifier onlyWhileOpen {
    require(now >= openingTime && now <= closingTime);
    _;
  }

  /**
   * @dev Constructor, takes crowdsale opening and closing times.
   * @param _times Crowdsale  time array
   */
  function TimedCrowdsale(
    uint256[] _times) public {
    require(_times.length >= 5);
    openingTime = _times[0];
    firstTimeEnd = _times[1];
    secondTimeEnd = _times[2];
    thirdTimeEnd = _times[3];
    closingTime = _times[4];
  }

  function isFirstPhase() public view returns (bool) {
    return (now >= openingTime && now <= firstTimeEnd);
  }

  function isSecondPhase() public view returns (bool) {
    return (now > firstTimeEnd && now <= secondTimeEnd);
  }

  function isThirdPhase() public view returns (bool) {
    return (now > secondTimeEnd && now <= thirdTimeEnd);
  }

  function isLastPhase() public view returns (bool) {
    return (now > thirdTimeEnd && now <= closingTime);
  }

  function getNow() public view returns (uint256) {
    return now;
  }

  /**
   * @dev Checks whether the period in which the crowdsale is open has already elapsed.
   * @return Whether crowdsale period has elapsed
   */
  function hasClosed() public view returns (bool) {
    return now > closingTime;
  }

  /**
   * @dev Extend parent behavior requiring to be within contributing period
   * @param _beneficiary Token purchaser
   * @param _weiAmount Amount of wei contributed
   */
  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }

}
