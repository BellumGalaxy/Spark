// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

/////////////
///Imports///
/////////////
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

////////////
///Errors///
////////////

///////////////////////////
///Interfaces, Libraries///
///////////////////////////

contract SparkToken is ERC20, ERC20Burnable, ERC20Permit, Ownable {
    constructor(address initialOwner)
        ERC20("Spark Token", "ST")
        ERC20Permit("Spark Token")
        Ownable(initialOwner)
    {}
}