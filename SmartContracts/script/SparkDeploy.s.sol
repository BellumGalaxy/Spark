// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Script, console2} from "forge-std/Script.sol";

import {Spark} from "../src/Spark.sol";

contract SparkDeploy is Script {
    function run(address _usdc, address _coordinator, address _clfRouter) public returns(Spark spark){
        vm.broadcast();
        spark = new Spark(_usdc, _coordinator, _clfRouter);
    }
}
