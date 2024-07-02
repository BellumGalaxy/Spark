// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

/////////////
///Imports///
/////////////
import {SparkToken} from "./SparkToken.sol";
import {SparkVault} from "./SparkVault.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

////////////
///Errors///
////////////

///////////////////////////
///Interfaces, Libraries///
///////////////////////////

contract Spark {
    ///////////////////////
    ///Type declarations///
    ///////////////////////
    using SafeERC20 for IERC20;

    ////////////////
    ///IMMUTABLES///
    ////////////////
    SparkToken immutable sparkToken;
    SparkVault immutable sparkVault;

    /////////////////////
    ///State variables///
    /////////////////////

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
    constructor(){
        sparkToken = new SparkToken(address(this));
        sparkVault = new SparkVault();
    }

    //////////////
    ///external///
    //////////////
    function athleteRegister() external returns(uint256 _athleteId){
        // _athleteId = VRFcall.
    }

    function sponsorRegister() external returns(uint256 _sponsorId){
        // _sponsorId = VRFcall.
    }

    function donate(uint256 _athleteId, uint256 _amount) external {
        // can donate in any coin
    }

    function sponsor(uint256 _athleteId, uint256 _shares) external {
        //Cada atleta tem um X de cotas.
        //Essas cotas variam de valor de acordo com o desempenho do atleta
    }

    function obtainSparks(uint256 _amount) external {
        //Pode comprar com X tokens. Precisamos do Data Feeds para converter para BRL
        //Ou paga em BRL e converte para USD-Something
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
