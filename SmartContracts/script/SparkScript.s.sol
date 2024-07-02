// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Script, console2} from "forge-std/Script.sol";

import {Spark} from "../src/Spark.sol";

contract SparkScript is Script {
    function setUp() public {}

    function run() public returns(Spark spark){
        vm.broadcast();
        spark = new Spark();
    }
}
