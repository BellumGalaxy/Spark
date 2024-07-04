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
error Spark_InsuficientBalanceToWithdraw(uint256 amount, uint256 amountReceived, uint256 amountValidated);
error Spark_ReceivedSponsorshipIsNotEnough(uint256 amount, uint256 sparkTokenBalance);
error Spark_CallerIsNotTheAthlete(address caller, address athlete);
error Spark_InvalidCampaing();
error Spark_CampaingCapReached(uint256 targetAmount, uint256 receivedAmount);

///////////////////////////
///Interfaces, Libraries///
///////////////////////////

contract Spark {
    ///////////////////////
    ///Type declarations///
    ///////////////////////
    using SafeERC20 for IERC20;

    struct Athlete{
        uint256 dateOfRegister;
        uint256 donationsReceived;
        uint256 sponsorsAmount;
        uint256 validatedAmount;
        uint256 amountSpent;
        uint256 sparkFactor;
        address athleteWallet;
    }

    struct Sponsors{
        uint256 dateOfRegister;
        uint256 amountSponsored;
        uint256 sparkFactor;
        address sponsorWallet;
    }

    struct Campaing{
        uint256 targetAmount;
        uint256 receivedAmount;
        uint256 duration;
        bytes reason;
    }

    ///////////////
    ///CONSTANTS///
    ///////////////
    ///@notice Magic number removal
    uint256 constant PROTOCOL_FEE = 1000;
    uint256 constant DRAWS_FEE = 1000;

    ////////////////
    ///IMMUTABLES///
    ////////////////
    SparkToken immutable i_sparkToken;
    SparkVault immutable i_sparkVault;
    IERC20 immutable i_USDC;
    
    /////////////////////
    ///State variables///
    /////////////////////
    uint256 s_protocolFeeAccrued;
    uint256 s_monthlyDrawAmount;
    uint256 s_athleteId;
    uint256 s_sponsorId;

    /////////////
    ///STORAGE///
    /////////////
    mapping(address giver => uint256 amount) public s_donationsRegister;
    mapping(address athleteAddress => Athlete) public s_athletes;
    mapping(address sponsorAddress => Sponsors) public s_sponsors;
    mapping(uint256 athleteId => address athleteWallet) public s_athleteIdentification;
    mapping(uint256 sponsorId => address sponsorWallet) public s_sponsorIdentification;
    mapping(uint256 athleteId => Campaing) public s_campaings;

    ////////////
    ///Events///
    ////////////
    event Spark_AthleteRegistered(uint256 athleteId);
    event Spark_SponsorRegistered(address sponsor);
    event Spark_SuccessFulDonation(uint256 athleteId, uint256 amount);
    event Spark_SponsorAthlete(uint256 athleteId, uint256 shares);
    event Spark_SparksObtained(uint256 amount);
    event Spark_AmountRedeemed(uint256 athleteId, uint256 amount);
    event Spark_NewCampaignCreated(uint256 athleteId, string reason, uint256 duration, uint256 amount);
    event Spark_CampaingAdopted(uint256 athleteId, uint256 amount);

    ///////////////
    ///Modifiers///
    ///////////////

    ///////////////
    ///Functions///
    ///////////////

    /////////////////
    ///constructor///
    /////////////////
    constructor(address _usdc){
        i_sparkToken = new SparkToken(address(this));
        i_sparkVault = new SparkVault(address(this), _usdc);
        i_USDC = IERC20(i_USDC);
    }

    //////////////
    ///external///
    //////////////
    function athleteRegister(address _walletToReceiveDonation) external returns(uint256 _athleteId){
        _athleteId = ++s_athleteId;

        s_athleteIdentification[_athleteId] = _walletToReceiveDonation;
        s_athletes[msg.sender] = Athlete({
            dateOfRegister: block.timestamp,
            donationsReceived: 0,
            sponsorsAmount: 0,
            validatedAmount: 0,
            amountSpent: 0,
            sparkFactor: 1,
            athleteWallet: _walletToReceiveDonation
        });

        emit Spark_AthleteRegistered(_athleteId);
    }

    function sponsorRegister(address _sponsorWallet) external returns(uint256 _sponsorId){
        _sponsorId = ++s_sponsorId;

        s_sponsorIdentification[_sponsorId] = _sponsorWallet;        
        s_sponsors[msg.sender] = Sponsors({
            dateOfRegister: block.timestamp,
            amountSponsored: 0,
            sparkFactor: 1,
            sponsorWallet: _sponsorWallet
        });

        emit Spark_SponsorRegistered(msg.sender);
    }

    /**
     * @notice Function to donate to Athletes
     * @param _athleteId the identification for each athelte
     * @param _token the token to transfer
     * @param _amount the amount to transfer
     * @dev The token received will be swapped into USDC and transferred to the Athlete.
     * @dev User can donate using any Uniswap-tradable token
     */
    function donate(uint256 _athleteId, IERC20 _token, uint256 _amount) external {
        address athleteAddress = s_athleteIdentification[_athleteId];
        Athlete storage athlete = s_athletes[athleteAddress];

        athlete.donationsReceived = athlete.donationsReceived + _amount;
        s_donationsRegister[msg.sender] = s_donationsRegister[msg.sender] + _amount;

        emit Spark_SuccessFulDonation(_athleteId, _amount);

        _token.transferFrom(msg.sender, athlete.athleteWallet, _amount);
    }

    //IMPROVEMENTS
        //Cada atleta tem um X de cotas.
        //Essas cotas variam de valor de acordo com o desempenho do atleta
    /**
     * @notice Function to allow Sponsorship payments
     * @param _athleteId the athlete that will receive
     * @param _shares amount of SparkToken to invest
     * @dev This function only accepts Spart Tokens.
     * @dev The cost to Sponsor an Athlete flutuate according with achievements.
     */
    function sponsor(uint256 _athleteId, uint256 _shares) external {
        address athleteAddress = s_athleteIdentification[_athleteId];
        Athlete storage athlete = s_athletes[athleteAddress];
        Sponsors storage sponsors = s_sponsors[msg.sender];

        athlete.sponsorsAmount = athlete.sponsorsAmount + _shares;
        sponsors.amountSponsored = sponsors.amountSponsored + _shares;

        emit Spark_SponsorAthlete(_athleteId, _shares);

        IERC20(i_sparkToken).safeTransferFrom(msg.sender, athlete.athleteWallet, _shares);
    }

    //Pode comprar com X tokens. Precisamos do Data Feeds para converter para BRL. UPDATE: Data feeds só disponível em mainnet
    //Ou paga em BRL e converte para USD-Something
    /**
     * @notice Function for Sponsors to acquire Sparks
     * @param _token the token to send
     * @param _amount the amount to send
     * @dev Sponsor needs to acquire Sparks in order to Sponsor Athletes
     */
    function obtainSparks(IERC20 _token, uint256 _amount) external {
        uint256 protocolFee = _amount/PROTOCOL_FEE;
        uint256 monthlyDraws = _amount/DRAWS_FEE;

        s_protocolFeeAccrued = s_protocolFeeAccrued + protocolFee;
        s_monthlyDrawAmount = s_monthlyDrawAmount + monthlyDraws;

        emit Spark_SparksObtained(_amount - protocolFee);

        _token.safeTransferFrom(msg.sender, address(this), _amount);        
        i_sparkToken.mint(msg.sender, _amount - protocolFee);
    }

    function redeemAmount(uint256 _athleteId, uint256 _amount) external {
        address athleteAddress = s_athleteIdentification[_athleteId];
        Athlete memory athlete = s_athletes[athleteAddress];
        if(_amount + athlete.amountSpent > athlete.sponsorsAmount || _amount + athlete.amountSpent > athlete.validatedAmount) revert Spark_InsuficientBalanceToWithdraw(_amount, athlete.sponsorsAmount, athlete.validatedAmount);
        if(_amount > i_sparkToken.balanceOf(msg.sender)) revert Spark_ReceivedSponsorshipIsNotEnough(_amount, i_sparkToken.balanceOf(msg.sender));

        athlete.amountSpent = athlete.amountSpent + _amount;

        IERC20(i_sparkToken).safeTransferFrom(msg.sender, address(this), _amount);
        i_sparkToken.burn(_amount);

        emit Spark_AmountRedeemed(_athleteId, _amount);

        i_sparkVault.redeem(athlete.athleteWallet, _amount);
    }

    function createCampaign(uint256 _athleteId, uint256 _amount, uint256 _duration, string memory _reason) external {
        if (s_athleteIdentification[_athleteId] != msg.sender) revert Spark_CallerIsNotTheAthlete(msg.sender, s_athleteIdentification[_athleteId]);

        s_campaings[_athleteId] = Campaing ({
            targetAmount: _amount,
            receivedAmount: 0,
            duration: block.timestamp + _duration,
            reason: abi.encode(_reason)
        });

        emit Spark_NewCampaignCreated(_athleteId, _reason, _duration, _amount);
    }

    function adoptCampain(uint256 _athleteId, uint256 _amount) external {
        Campaing storage campaing = s_campaings[_athleteId];
        if(campaing.duration < block.timestamp) revert Spark_InvalidCampaing();
        if(campaing.receivedAmount +_amount > campaing.targetAmount) revert Spark_CampaingCapReached(campaing.targetAmount, campaing.targetAmount - campaing.receivedAmount);

        campaing.receivedAmount = campaing.receivedAmount + _amount;

        emit Spark_CampaingAdopted(_athleteId, _amount);

        i_USDC.safeTransferFrom(msg.sender, s_athleteIdentification[_athleteId], _amount);
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
    function getAthleteInfos(uint256 _athleteId) external view returns(Athlete memory athlete){
        address athleteAddress = s_athleteIdentification[_athleteId];

        athlete = s_athletes[athleteAddress];
    }

    function getSponsorInfo(uint256 _sponsorId) external view returns(Sponsors memory sponsors){
        address sponsorAddress = s_sponsorIdentification[_sponsorId];
        sponsors = s_sponsors[sponsorAddress];
    }
}
