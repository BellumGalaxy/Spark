// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Test, console2} from "forge-std/Test.sol";

//=========== Contracts
import {Spark} from "../../src/Spark.sol";

//=========== Scripts
import {SparkScript} from "../../script/SparkScript.s.sol";

contract SparkTest is Test {
    Spark spark;
    SparkScript sparkDeploy;

    address usdc;
    address coordinator;

    function setUp() public {
        sparkDeploy = new SparkScript();

        spark = sparkDeploy.run(usdc, coordinator);
    }

}
