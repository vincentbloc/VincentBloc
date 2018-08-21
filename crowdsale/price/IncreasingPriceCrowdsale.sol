pragma solidity ^0.4.18;

import "../validation/TimedCrowdsale.sol";
import "../../math/SafeMath.sol";

/**
 * @title IncreasingPriceCrowdsale
 * @dev Extension of Crowdsale contract that increases the price of tokens linearly in time.
 * Note that what should be provided to the constructor is the initial and final _rates_, that is,
 * the amount of tokens per wei contributed. Thus, the initial rate must be greater than the final rate.
 */
contract IncreasingPriceCrowdsale is TimedCrowdsale {
  using SafeMath for uint256;

  uint256 public firstPhaseRate;
  uint256 public secondPhaseRate;
  uint256 public thirdPhaseRate;
  uint256 public forthPhaseRate;
  uint256 public finalRate;

  /**
   * @dev Constructor, takes intial and final rates of tokens received per wei contributed.
   * @param _rates Number of tokens a buyer gets per wei at the start of the crowdsale
   *
   */
  function IncreasingPriceCrowdsale(
    uint256[] _rates) public {
    rate = _rates[0];
    firstPhaseRate = _rates[0];
    secondPhaseRate = _rates[1];
    thirdPhaseRate = _rates[2];
    forthPhaseRate = _rates[3];
    finalRate = _rates[4];
  }

  /**
   * @dev Returns the rate of tokens per wei at the present time.
   * Note that, as price _increases_ with time, the rate _decreases_.
   * @return The number of tokens a buyer gets per wei at a given time
   */
  function getCurrentRate() public view returns (uint256) {
    uint256 calRate = 1;
    if (isFirstPhase()) {
      calRate = firstPhaseRate;
    } else if (isSecondPhase()) {
      calRate = secondPhaseRate;
    } else if (isThirdPhase()) {
      calRate = thirdPhaseRate;
    } else {
      uint256 elapsedTime = now.sub(thirdTimeEnd);
      uint256 timeRange = closingTime.sub(thirdTimeEnd);
      uint256 rateRange = forthPhaseRate.sub(finalRate);
      calRate = forthPhaseRate.sub(elapsedTime.mul(rateRange).div(timeRange));
    }
    return calRate;
  }

  /**
   * @dev Overrides parent method taking into account variable rate.
   * @param _weiAmount The value in wei to be converted into tokens
   * @return The number of tokens _weiAmount wei will buy at present time
   */
  function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
    uint256 currentRate = getCurrentRate();
    return currentRate.mul(_weiAmount);
  }

}
