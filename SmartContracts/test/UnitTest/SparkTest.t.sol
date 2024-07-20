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

    ///================ Adopt Campaing
    error Spark_CampaingCapReached(uint256,uint256);
    error Spark_InvalidCampaing();
    event Spark_CampaingAdopted(uint256, uint256);
    function test_adoptCampaing() public {
        uint256 athleteId = 1;
        uint256 targetAmount = 10*10**6;
        uint256 duration = 1 days;
        string memory reason = "Comprar Equipamentos Novos";

        vm.prank(Atleta);
        vm.expectEmit();
        emit Spark_AthleteRegistered(athleteId);
        (, bytes32 _requestId) = spark.athleteRegister();

        //==== Manually update the request
        spark.manuallyFulfillRequest(_requestId, abi.encode(true), new bytes(0));
        
        vm.prank(Atleta);
        vm.expectEmit();
        emit Spark_NewCampaignCreated(athleteId, reason, duration, targetAmount);
        spark.createCampaign(athleteId, targetAmount, duration, reason);

        vm.prank(Barba);
        vm.expectRevert(abi.encodeWithSelector(Spark_CampaingCapReached.selector, targetAmount, targetAmount));
        spark.adoptCampain(athleteId, 100*10**6);

        vm.startPrank(Barba);
        usdc.approve(address(spark), targetAmount);

        vm.expectEmit();
        emit Spark_CampaingAdopted(athleteId, targetAmount);
        spark.adoptCampain(athleteId, targetAmount);
        vm.stopPrank();

        vm.warp(block.timestamp + 2 days);
        
        vm.prank(Barba);
        vm.expectRevert(abi.encodeWithSelector(Spark_InvalidCampaing.selector));
        spark.adoptCampain(athleteId, targetAmount);
        vm.stopPrank();
    }

    ///================ Donate
    error Spark_AthleteNotValidated(bool);
    event Spark_SuccessFulDonation(address, uint256, address);
    function test_donate() public {
        uint256 targetAmount = 10*10**6;

        vm.prank(Atleta);
        (uint256 athleteId, bytes32 _requestId) = spark.athleteRegister();

        vm.warp(block.timestamp + 2 hours);
        
        vm.prank(Doador);
        (bytes32 requestId) = spark.benefactorRegister();

        vm.prank(Doador);
        vm.expectRevert(abi.encodeWithSelector(Spark_AthleteNotValidated.selector, false));
        spark.donate(athleteId, targetAmount);

        //==== Manually update the request
        spark.manuallyFulfillRequest(_requestId, abi.encode(true), new bytes(0));

        vm.prank(Doador);
        vm.expectRevert(abi.encodeWithSelector(Spark_VerifyYourProfileFirst.selector, false));
        spark.donate(athleteId, targetAmount);

        //==== Manually update the request
        spark.manuallyFulfillRequest(requestId, abi.encode(true), new bytes(0));

        vm.startPrank(Doador);
        usdc.approve(address(spark), targetAmount);
        vm.expectEmit();
        emit Spark_SuccessFulDonation(Atleta, targetAmount, Doador);
        spark.donate(athleteId, targetAmount);
    }

    ///================ Swaping for Spark
    event Spark_SparksObtained(uint256);
    function test_obtainSparks() public {
        IERC20 sparks = spark.i_sparkToken();
        assertEq(sparks.balanceOf(Barba), 0);

        vm.startPrank(Barba);
        usdc.approve(address(spark), 100*10**6);
        vm.expectEmit();
        emit Spark_SparksObtained(100*10**6 - (100*10**6 / 1000));
        spark.obtainSparks(100*10**6);
        
        assertEq(sparks.balanceOf(Barba), 999*10**17);
    }

    ///================ Sponsor
    event Spark_SponsorAthlete(uint256 athleteId, uint256);
    function test_sponsorAthlete() public {
        IERC20 sparks = spark.i_sparkToken();

        assertEq(sparks.balanceOf(Atleta), 0);
        assertEq(sparks.balanceOf(Patrocinador), 0);

        vm.prank(Atleta);
        (uint256 _athleteId, bytes32 _requestId) = spark.athleteRegister();

        vm.prank(Patrocinador);
        (, bytes32 requestId) = spark.sponsorRegister();

        assertEq(usdc.balanceOf(address(spark.i_sparkVault())), 0);

        vm.startPrank(Patrocinador);
        usdc.approve(address(spark), 10*10**6);
        spark.obtainSparks(10*10**6);
        vm.stopPrank();
        
        assertEq(sparks.balanceOf(Patrocinador), 999*10**16);
        assertEq(usdc.balanceOf(address(spark.i_sparkVault())), 10*10**6 - (10*10**6 / 1000));

        vm.prank(Patrocinador);
        vm.expectRevert(abi.encodeWithSelector(Spark_AthleteNotValidated.selector, false));
        spark.sponsor(_athleteId, 10*10**18);

        //==== Manually update the request
        spark.manuallyFulfillRequest(_requestId, abi.encode(true), new bytes(0));
        
        vm.prank(Patrocinador);
        vm.expectRevert(abi.encodeWithSelector(Spark_VerifyYourProfileFirst.selector, false));
        spark.sponsor(_athleteId, 10*10**18);

        //==== Manually update the request
        spark.manuallyFulfillRequest(requestId, abi.encode(true), new bytes(0));

        vm.startPrank(Patrocinador);
        sparks.approve(address(spark), 999*10**16);
        vm.expectEmit();
        emit Spark_SponsorAthlete(_athleteId, 999*10**16);
        spark.sponsor(_athleteId, 999*10**16);
        vm.stopPrank();

        assertEq(sparks.balanceOf(Atleta), 999*10**16);

        // vm.startPrank(Atleta);
        // sparks.approve(address(spark), 999*10**16);
        // vm.expectEmit();
        // emit Spark_AmountRedeemed(_athleteId, 999*10**16);
        // spark.redeemAmount(_athleteId, 999*10**16);
    }
}
