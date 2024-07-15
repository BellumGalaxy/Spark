// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Script, console2} from "forge-std/Script.sol";

import {Spark} from "../src/Spark.sol";

contract SparkScript is Script {
    address usdc = 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238;
    address coordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
    address clfRouter = 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0;
    function run(/*address _usdc, address _coordinator, address _clfRouter*/) public returns(Spark spark){
        vm.broadcast();
        spark = new Spark(usdc, coordinator, clfRouter);
    }
}
