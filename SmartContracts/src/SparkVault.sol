// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

/////////////
///Imports///
/////////////
import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

////////////
///Errors///
////////////
error SparkVault_CallerNotAllowed(address);

///////////////////////////
///Interfaces, Libraries///
///////////////////////////

contract SparkVault {
    ///////////////////////
    ///Type declarations///
    ///////////////////////
    using SafeERC20 for IERC20;

    ///////////////
    ///CONSTANTS///
    ///////////////

    ////////////////
    ///IMMUTABLES///
    ////////////////
    address immutable i_spark;
    address immutable i_USDC;

    /////////////////////
    ///State variables///
    /////////////////////

    /////////////
    ///STORAGE///
    /////////////

    ////////////
    ///Events///
    ////////////

    ///////////////
    ///Modifiers///
    ///////////////

    ///////////////
    ///Functions///
    ///////////////

    /////////////////
    ///constructor///
    /////////////////
    constructor(address _spark, address _usdc){
        i_spark = _spark;
        i_USDC = _usdc;
    }

    //////////////
    ///external///
    //////////////
    function redeem(address _athlete, uint256 _amount) external {
        if(msg.sender != i_spark) revert SparkVault_CallerNotAllowed(msg.sender);

        IERC20(i_USDC).safeTransfer(_athlete, _amount);
    }

    ////////////
    ///public///
    ////////////

    //////////////
    ///internal///
    //////////////

    /////////////
    ///private///
    /////////////

    /////////////////
    ///view & pure///
    /////////////////
}