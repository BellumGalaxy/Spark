// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Test, console2} from "forge-std/Test.sol";

//=========== Contracts
import {Spark} from "../../src/Spark.sol";

//=========== Scripts
import {SparkDeploy} from "../../script/SparkDeploy.s.sol";

//=========== Open Zeppelin
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//=========== Chainlink Imports
import {FunctionsRouter} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/FunctionsRouter.sol";

contract SparkTest is Test {
    Spark spark;
    SparkDeploy sparkDeploy;

    //==== SubOwner
    address Barba = 0xB015a6318f1D19DC3E135C8cEBa4bda00845c9Be;
    address Doador = makeAddr("Doador");
    address Patrocinador = makeAddr("Patrocinador");
    address Atleta = makeAddr("Atleta");

    //==== TestNet Variables
    IERC20 usdc = IERC20(0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238);
    address coordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
    FunctionsRouter clfRouter = FunctionsRouter(0xb83E47C2bC239B3bf370bc41e1459A34b41238D0);

    //==== Fork Test
    uint256 sepoliaFork;
    string SEP_TESTNET_RPC_URL = vm.envString("SEP_TESTNET_RPC_URL");

    function setUp() public {
        sepoliaFork = vm.createSelectFork(SEP_TESTNET_RPC_URL);
        
        vm.selectFork(sepoliaFork);

        sparkDeploy = new SparkDeploy();

        spark = sparkDeploy.run(address(usdc), coordinator, address(clfRouter));
        
        //==== Register Contract on CLF
        vm.prank(Barba);
        clfRouter.addConsumer(3221, address(spark));

        //==== Borrow some USDC
        vm.prank(0xF745b439965c66425958159e91E7e04224Fed29D);
        usdc.transfer(Barba, 1000*10**6);
        vm.prank(0xF745b439965c66425958159e91E7e04224Fed29D);
        usdc.transfer(Doador, 100*10**6);
        vm.prank(0xF745b439965c66425958159e91E7e04224Fed29D);
        usdc.transfer(Patrocinador, 100*10**6);
    }

    ///================ Register Functions
    event Spark_BenefactorRegistered(address);
    error Spark_BenefactorAlreadyRegistered(address);
    function test_benefactorRegister() public {
        vm.prank(Doador);
        vm.expectEmit();
        emit Spark_BenefactorRegistered(Doador);
        spark.benefactorRegister();

        Spark.Benefactor memory benefactor = spark.getBenefactorInfo(Doador);

        assertEq(benefactor.dateOfRegister, block.timestamp);
        assertEq(benefactor.benefactorWallet, Doador);
        assertEq(benefactor.isValidated, false);

        vm.prank(Doador);
        vm.expectRevert(abi.encodeWithSelector(Spark_BenefactorAlreadyRegistered.selector, Doador));
        spark.benefactorRegister();
    }

    event Spark_AthleteRegistered(uint256);
    error Spark_AthleteAlreadyRegistered(address);
    function test_athleteRegister() public {
        uint256 athleteId = 1;

        vm.prank(Atleta);
        vm.expectEmit();
        emit Spark_AthleteRegistered(athleteId);
        spark.athleteRegister();

        Spark.Athlete memory atleta = spark.getAthleteInfos(athleteId);

        assertEq(atleta.dateOfRegister, block.timestamp);
        assertEq(atleta.athleteWallet, Atleta);
        assertEq(atleta.isValidated, false);

        vm.prank(Atleta);
        vm.expectRevert(abi.encodeWithSelector(Spark_AthleteAlreadyRegistered.selector, Atleta));
        spark.athleteRegister();
    }
    
    event Spark_SponsorRegistered(uint256);
    error Spark_SponsorAlreadyRegistered(address);
    function test_sponsorRegister() public {
        uint256 sponsorId = 1;

        vm.prank(Patrocinador);
        vm.expectEmit();
        emit Spark_SponsorRegistered(sponsorId);
        spark.sponsorRegister();

        Spark.Sponsors memory sponsor = spark.getSponsorInfo(sponsorId);

        assertEq(sponsor.dateOfRegister, block.timestamp);
        assertEq(sponsor.sponsorWallet, Patrocinador);
        assertEq(sponsor.isValidated, false);

        vm.prank(Patrocinador);
        vm.expectRevert(abi.encodeWithSelector(Spark_SponsorAlreadyRegistered.selector, Patrocinador));
        spark.sponsorRegister();
    }

    ///================ Create Campaing
    error Spark_VerifyYourProfileFirst(bool isValidated);
    event Spark_NewCampaignCreated(uint256 athleteId, string reason, uint256 duration, uint256 amount);
    function test_createCampaign() public {
        uint256 athleteId = 1;
        uint256 targetAmount = 10*10**6;
        uint256 duration = 1 days;
        string memory reason = "Comprar Equipamentos Novos";

        vm.prank(Atleta);
        vm.expectEmit();
        emit Spark_AthleteRegistered(athleteId);
        (, bytes32 _requestId) = spark.athleteRegister();

        vm.prank(Atleta);
        vm.expectRevert(abi.encodeWithSelector(Spark_VerifyYourProfileFirst.selector, false));
        spark.createCampaign(athleteId, targetAmount, duration, reason);

        spark.manuallyFulfillRequest(_requestId, abi.encode(true), new bytes(0));
        
        vm.prank(Atleta);
        vm.expectEmit();
        emit Spark_NewCampaignCreated(athleteId, reason, duration, targetAmount);
        spark.createCampaign(athleteId, targetAmount, duration, reason);

        Spark.Campaing memory campaing = spark.getCampaignInfos(athleteId);
        assertEq(campaing.targetAmount, targetAmount);
        assertEq(campaing.receivedAmount, 0);
        assertEq(campaing.duration, block.timestamp + duration);
    }
}
