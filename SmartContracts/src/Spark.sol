// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

/////////////
///Imports///
/////////////
///Protocol Contracts
import {SparkToken} from "./SparkToken.sol";
import {SparkVault} from "./SparkVault.sol";

/// OpenZeppelin Imports
import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

///Vrf Imports
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
///Functions Imports
import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/v1_0_0/libraries/FunctionsRequest.sol";

////////////
///Errors///
////////////
error Spark_BenefactorAlreadyRegistered(address benefactorAddress);
error Spark_InsuficientBalanceToWithdraw(uint256 amount, uint256 amountReceived, uint256 amountValidated);
error Spark_ReceivedSponsorshipIsNotEnough(uint256 amount, uint256 sparkTokenBalance);
error Spark_CallerIsNotTheAthlete(address caller, address athlete);
error Spark_InvalidCampaing();
error Spark_CampaingCapReached(uint256 targetAmount, uint256 receivedAmount);
error Spark_RequestNotFound(uint256 requestId);
error Spark_UnexpectedRequestID(bytes32 requestId);

///////////////////////////
///Interfaces, Libraries///
///////////////////////////

/**
 * @title Spark - Athletes Crowdfunding & Sponsoring System
 * @author Bellum Galaxy Hackathon Division - Barba
 * @notice This is a non deeply tested hackathon project and must not be used in production.
 * @custom:contact www.bellumgalaxy.com.br
 */
contract Spark is VRFConsumerBaseV2Plus, FunctionsClient {
    ///////////////////////
    ///Type declarations///
    ///////////////////////
    using SafeERC20 for IERC20;
    using FunctionsRequest for FunctionsRequest.Request;

    struct Benefactor{
        uint256 dateOfRegister;
        uint256 donatedAmount;
        address benefactorWallet;
        bool isValidated;
    }

    struct Athlete{
        uint256 dateOfRegister;
        uint256 donationsReceived;
        uint256 sponsorsAmount;
        uint256 validatedAmount;
        uint256 amountSpent;
        uint256 sparkFactor;
        address athleteWallet;
        bool isValidated;
    }

    struct Sponsors{
        uint256 dateOfRegister;
        uint256 amountSponsored;
        uint256 sparkFactor;
        address sponsorWallet;
        bool isValidated;
    }

    struct Campaing{
        uint256 targetAmount;
        uint256 receivedAmount;
        uint256 duration;
        bytes reason;
    }

    struct RequestStatus {
        uint256 randomWords;
        uint256 selectedNumber;
        bool fulfilled;
        bool exists;
    }

    ///////////////
    ///CONSTANTS///
    ///////////////
    ///@notice Magic number removal
    uint256 constant PROTOCOL_FEE = 1000;
    uint256 constant DRAWS_FEE = 1000;
    ///@notice Chainlink VRF Variables
    uint256 private constant SUBSCRIPTION_ID = 32641048211472861203069745922496548680493389780543789840765072168299730666388;
    bytes32 private constant KEY_HASH = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 private constant CALLBACK_GAS_LIMIT = 100_000;
    uint32 private constant NUM_WORDS = 2;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    ///@notice Chainlink Functions Variables
    uint64 private constant CLF_SUBSCRIPTION_ID = 3221;
    uint32 private constant GAS_LIMIT = 300_000;
    bytes32 private constant DON_ID = 0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000;
    string private constant JS_CODE = "";

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
    address[] private s_luckyBenefactors;

    mapping(address benefactorAddress => Benefactor) public s_benefactors;
    mapping(address athleteAddress => Athlete) public s_athletes;
    mapping(address sponsorAddress => Sponsors) public s_sponsors;
    mapping(address giver => uint256 amount) public s_donationsRegister;
    mapping(uint256 athleteId => address athleteWallet) public s_athleteIdentification;
    mapping(uint256 sponsorId => address sponsorWallet) public s_sponsorIdentification;
    mapping(uint256 athleteId => Campaing) public s_campaings;
    mapping(uint256 requestId => RequestStatus) public s_requests;
    mapping(bytes32 requestId => address user) public s_clfRequest;

    ////////////
    ///Events///
    ////////////
    event Spark_BenefactorRegistered(address benefactorAddress);
    event Spark_AthleteRegistered(uint256 athleteId);
    event Spark_SponsorRegistered(address sponsor);
    event Spark_SuccessFulDonation(uint256 athleteId, uint256 amount);
    event Spark_SponsorAthlete(uint256 athleteId, uint256 shares);
    event Spark_SparksObtained(uint256 amount);
    event Spark_AmountRedeemed(uint256 athleteId, uint256 amount);
    event Spark_NewCampaignCreated(uint256 athleteId, string reason, uint256 duration, uint256 amount);
    event Spark_CampaingAdopted(uint256 athleteId, uint256 amount);
    event Spart_RequestSent(uint256 requestId, uint256 numWords);
    event Spart_RequestFulfilled(uint256 requestId, uint256 randomWords, uint256 selectedNumber);
    event Spark_BenefactorRewarded(address winnerAddress, uint256 amountToPay);
    event Spark_Response(bytes32 requestId, bytes response, bytes err);

    ///////////////
    ///Modifiers///
    ///////////////

    ///////////////
    ///Functions///
    ///////////////

    /////////////////
    ///constructor///
    /////////////////
    constructor(address _usdc, address _vrfCoordinator, address _router) VRFConsumerBaseV2Plus(_vrfCoordinator) FunctionsClient(_router){ //VRF: 0x9ddfaca8183c41ad55329bdeed9f6a8d53168b1b CLF: 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0
        i_sparkToken = new SparkToken(address(this));
        i_sparkVault = new SparkVault(address(this), _usdc);
        i_USDC = IERC20(i_USDC);
    }

    //////////////
    ///external///
    //////////////
    function benefactorRegister() external returns(bytes32 _requestId){
        if(s_benefactors[msg.sender].dateOfRegister != 0) revert Spark_BenefactorAlreadyRegistered(msg.sender);

        s_benefactors[msg.sender] = Benefactor({
            dateOfRegister: block.timestamp,
            donatedAmount: 0,
            benefactorWallet: msg.sender,
            isValidated: false
        });

        emit Spark_BenefactorRegistered(msg.sender);

        bytes[] memory args = new bytes[](1);
        args[0] = abi.encodePacked(msg.sender);

        _requestId = _sendRequest(args, msg.sender);
    }

    function athleteRegister(address _walletToReceiveDonation) external returns(uint256 _athleteId, bytes32 _requestId){
        _athleteId = ++s_athleteId;

        s_athleteIdentification[_athleteId] = _walletToReceiveDonation;
        s_athletes[msg.sender] = Athlete({
            dateOfRegister: block.timestamp,
            donationsReceived: 0,
            sponsorsAmount: 0,
            validatedAmount: 0,
            amountSpent: 0,
            sparkFactor: 1,
            athleteWallet: _walletToReceiveDonation,
            isValidated: false
        });

        emit Spark_AthleteRegistered(_athleteId);

        bytes[] memory args = new bytes[](2);
        args[0] = abi.encodePacked(_athleteId);
        args[1] = abi.encodePacked(_walletToReceiveDonation);

        _requestId = _sendRequest(args, _walletToReceiveDonation);
    }

    function sponsorRegister(address _sponsorWallet) external returns(uint256 _sponsorId, bytes32 _requestId){
        _sponsorId = ++s_sponsorId;

        s_sponsorIdentification[_sponsorId] = _sponsorWallet;        
        s_sponsors[msg.sender] = Sponsors({
            dateOfRegister: block.timestamp,
            amountSponsored: 0,
            sparkFactor: 1,
            sponsorWallet: _sponsorWallet,
            isValidated: false
        });

        emit Spark_SponsorRegistered(msg.sender);

        bytes[] memory args = new bytes[](2);
        args[0] = abi.encodePacked(_sponsorId);
        args[1] = abi.encodePacked(_sponsorWallet);

        _requestId = _sendRequest(args, _sponsorWallet);
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
        s_luckyBenefactors.push(msg.sender);
        s_monthlyDrawAmount = s_monthlyDrawAmount + ( _amount / DRAWS_FEE);

        emit Spark_SuccessFulDonation(_athleteId, _amount);

        _token.transferFrom(msg.sender, athlete.athleteWallet, (_amount - ( _amount / DRAWS_FEE)));
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

    //CALLED BY AUTOMATION
    function requestRandomWords() external returns (uint256 _requestId) {
        
        _requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: KEY_HASH,
                subId: SUBSCRIPTION_ID,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: CALLBACK_GAS_LIMIT,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: false
                    })
                )
            })
        );

        s_requests[_requestId] = RequestStatus({
            randomWords: 0,
            selectedNumber: 0,
            fulfilled: false,
            exists: true
        });

        emit Spart_RequestSent(_requestId, NUM_WORDS);
    }

    /**
     * @notice Send a simple request
     * @param _bytesArgs Array of bytes arguments, represented as hex strings
    */
    function _sendRequest(bytes[] memory _bytesArgs, address _user) internal returns (bytes32 _requestId) {
        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(JS_CODE);
        if (_bytesArgs.length > 0) req.setBytesArgs(_bytesArgs);

        _requestId = _sendRequest(
            req.encodeCBOR(),
            CLF_SUBSCRIPTION_ID,
            GAS_LIMIT,
            DON_ID
        );

        s_clfRequest[_requestId] =  _user;
    }

    /**
     * @notice Store latest result/error
     * @param _requestId The request ID, returned by sendRequest()
     * @param _response Aggregated response from the user code
     * @param _err Aggregated error from the user code or from the execution pipeline
     * Either response or error parameter will be set, but never both
     */
    function fulfillRequest(bytes32 _requestId, bytes memory _response, bytes memory _err) internal override {
        if (s_clfRequest[_requestId] == address(0))  revert Spark_UnexpectedRequestID(_requestId);

        emit Spark_Response(_requestId, _response, _err);
    }

    ////////////
    ///public///
    ////////////

    //////////////
    ///internal///
    //////////////
    function fulfillRandomWords(uint256 _requestId, uint256[] calldata _randomWords) internal override {
        RequestStatus storage request = s_requests[_requestId];
        if(request.exists == false) revert Spark_RequestNotFound(_requestId);

        request.fulfilled = true;
        request.randomWords = _randomWords[0];
        request.selectedNumber = _randomWords[0] % s_luckyBenefactors.length;

        emit Spart_RequestFulfilled(_requestId, _randomWords[0], request.selectedNumber);

        _rewardBenefactors(request.selectedNumber);
    }

    /////////////
    ///private///
    /////////////
    function _rewardBenefactors(uint256 selectedNumber) private {
        address winnerAddress = s_luckyBenefactors[selectedNumber];
        uint256 amountToPay = s_monthlyDrawAmount;

        s_monthlyDrawAmount = 0;
        delete s_luckyBenefactors;

        emit Spark_BenefactorRewarded(winnerAddress, amountToPay);

        i_USDC.safeTransfer(winnerAddress, amountToPay);
    }

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

    function getRequestStatus(uint256 _requestId) external view returns (bool fulfilled, uint256 randomWords) {
        if(s_requests[_requestId].exists == false) revert Spark_RequestNotFound(_requestId);

        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }
}
