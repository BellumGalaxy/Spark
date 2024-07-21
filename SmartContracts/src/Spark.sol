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
error Spark_AthleteAlreadyRegistered(address athleteAddress);
error Spark_SponsorAlreadyRegistered(address sponsorAddress);
error Spark_InsuficientBalanceToWithdraw(uint256 amount, uint256 amountReceived, uint256 amountValidated);
error Spark_ReceivedSponsorshipIsNotEnough(uint256 amount, uint256 sparkTokenBalance);
error Spark_VerifyYourProfileFirst(bool isValidated);
error Spark_AthleteNotValidated(bool isValidated);
error Spark_InvalidCampaing();
error Spark_CampaingCapReached(uint256 targetAmount, uint256 receivedAmount);
error Spark_RequestNotFound(uint256 requestId);
error Spark_CallerNotAllowed();
error Spark_AlreadyUpdated();
error Spark_NotEnoughFunds();

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

    enum UserType {
        Athlete,
        Benefactor,
        Sponsor
    }

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

    struct CLFRequest {
        address user;
        UserType userType;
    }

    ///////////////
    ///CONSTANTS///
    ///////////////
    ///@notice Magic number removal
    uint256 constant PROTOCOL_FEE = 1000;
    uint256 constant DRAWS_FEE = 1000;
    uint256 constant ALLOWED = 1;
    uint256 constant USDC_DECIMALS = 10**6;
    uint256 constant STANDART_DECIMALS = 10**18;
    ///@notice Chainlink VRF Variables
    uint256 private constant SUBSCRIPTION_ID = 32641048211472861203069745922496548680493389780543789840765072168299730666388;
    bytes32 private constant KEY_HASH = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 private constant CALLBACK_GAS_LIMIT = 350_000;
    uint32 private constant NUM_WORDS = 1;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    ///@notice Chainlink Functions Variables
    uint64 private constant CLF_SUBSCRIPTION_ID = 3221;
    uint32 private constant GAS_LIMIT = 300_000;
    bytes32 private constant DON_ID = 0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000;
    string private constant JS_CODE = 
        "const userAddress = args[0];"
        "const response = await Functions.makeHttpRequest({"
        "url: `http://142.93.189.23:8000/api/users/user/${userAddress}/`,"
        "method: 'GET',"
        "});"
        "if (response.error) {"
        "  throw Error(`Request failed message ${response.message}`);"
        "}"
        "const { data } = response;"
        "return Functions.encodeUint256(data.isValidated);"
    ;

    ////////////////
    ///IMMUTABLES///
    ////////////////
    SparkToken public immutable i_sparkToken;
    SparkVault public immutable i_sparkVault;
    IERC20 immutable i_USDC;
    
    /////////////////////
    ///State variables///
    /////////////////////
    uint256 s_protocolFeeAccrued;
    uint256 s_monthlyDrawAmount;
    uint256 s_athleteId;
    uint256 s_sponsorId;
    address s_automationsForwarder;

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
    mapping(bytes32 requestId => CLFRequest) public s_clfRequest;

    ////////////
    ///Events///
    ////////////
    event Spark_BenefactorRegistered(address benefactorAddress);
    event Spark_AthleteRegistered(uint256 athleteId);
    event Spark_SponsorRegistered(uint256 sponsorId);
    event Spark_SuccessFulDonation(address athleteWallet, uint256 amount, address benefactor);
    event Spark_SponsorAthlete(uint256 athleteId, uint256 shares);
    event Spark_SparksObtained(uint256 amount);
    event Spark_AmountRedeemed(uint256 athleteId, uint256 amount);
    event Spark_NewCampaignCreated(uint256 athleteId, string reason, uint256 duration, uint256 amount);
    event Spark_CampaingAdopted(uint256 athleteId, uint256 amount);
    event Spart_RequestSent(uint256 requestId, uint256 numWords);
    event Spart_RequestFulfilled(uint256 requestId, uint256 randomWords, uint256 selectedNumber);
    event Spark_BenefactorRewarded(address winnerAddress, uint256 amountToPay);
    event Spark_Response(bytes32 requestId, bytes response, bytes err);
    event Spark_RequestFailed(bytes32 requestId);

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
        i_USDC = IERC20(_usdc);
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

        string[] memory args = new string[](1);
        args[0] = _addressToString(msg.sender);

        _requestId = _sendRequest(args, UserType.Benefactor);
        s_clfRequest[_requestId] = CLFRequest({
            user: msg.sender,
            userType: UserType.Benefactor
        });
    }

    function athleteRegister() external returns(uint256 _athleteId, bytes32 _requestId){
        if(s_athletes[msg.sender].dateOfRegister != 0) revert Spark_AthleteAlreadyRegistered(msg.sender);
        
        _athleteId = ++s_athleteId;

        s_athleteIdentification[_athleteId] = msg.sender;
        s_athletes[msg.sender] = Athlete({
            dateOfRegister: block.timestamp,
            donationsReceived: 0,
            sponsorsAmount: 0,
            validatedAmount: 0,
            amountSpent: 0,
            sparkFactor: 1,
            athleteWallet: msg.sender,
            isValidated: false
        });

        emit Spark_AthleteRegistered(_athleteId);

        string[] memory args = new string[](1);
        args[0] = _addressToString(msg.sender);

        _requestId = _sendRequest(args, UserType.Athlete);
        s_clfRequest[_requestId] = CLFRequest({
            user: msg.sender,
            userType: UserType.Athlete
        });
    }

    function sponsorRegister() external returns(uint256 _sponsorId, bytes32 _requestId){
        if(s_sponsors[msg.sender].dateOfRegister != 0) revert Spark_SponsorAlreadyRegistered(msg.sender);
        _sponsorId = ++s_sponsorId;

        s_sponsorIdentification[_sponsorId] = msg.sender;        
        s_sponsors[msg.sender] = Sponsors({
            dateOfRegister: block.timestamp,
            amountSponsored: 0,
            sparkFactor: 1,
            sponsorWallet: msg.sender,
            isValidated: false
        });

        emit Spark_SponsorRegistered(s_sponsorId);

        string[] memory args = new string[](1);
        args[0] = _addressToString(msg.sender);

        _requestId = _sendRequest(args, UserType.Sponsor);
        s_clfRequest[_requestId] = CLFRequest({
            user: msg.sender,
            userType: UserType.Sponsor
        });
    }

    function createCampaign(uint256 _athleteId, uint256 _amount, uint256 _duration, string memory _reason) external {
        if (s_athletes[msg.sender].isValidated == false) revert Spark_VerifyYourProfileFirst(s_athletes[msg.sender].isValidated);

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
     * @param _amount the amount to transfer
     * @dev The token received will be swapped into USDC and transferred to the Athlete.
     * @dev User can donate using any Uniswap-tradable token
     */
    function donate(uint256 _athleteId, uint256 _amount) external {
        address athleteAddress = s_athleteIdentification[_athleteId];
        Athlete storage athlete = s_athletes[athleteAddress];
        if (athlete.isValidated == false) revert Spark_AthleteNotValidated(s_athletes[msg.sender].isValidated);
        if (s_benefactors[msg.sender].isValidated == false) revert Spark_VerifyYourProfileFirst(s_benefactors[msg.sender].isValidated);

        athlete.donationsReceived = athlete.donationsReceived + _amount;
        s_donationsRegister[msg.sender] = s_donationsRegister[msg.sender] + _amount;
        s_luckyBenefactors.push(msg.sender);
        s_monthlyDrawAmount = s_monthlyDrawAmount + ( _amount / DRAWS_FEE);

        emit Spark_SuccessFulDonation(athleteAddress, _amount, msg.sender);

        i_USDC.transferFrom(msg.sender, athlete.athleteWallet, (_amount - ( _amount / DRAWS_FEE)));
    }

    /**
     * @notice Function for Sponsors to acquire Sparks
     * @param _amount the amount to send
     * @dev Sponsor needs to acquire Sparks in order to Sponsor Athletes
     */
    function obtainSparks(uint256 _amount) external {
        uint256 protocolFee = _amount/PROTOCOL_FEE;
        uint256 monthlyDraws = _amount/DRAWS_FEE;

        s_protocolFeeAccrued = s_protocolFeeAccrued + protocolFee;
        s_monthlyDrawAmount = s_monthlyDrawAmount + monthlyDraws;

        emit Spark_SparksObtained(_amount - protocolFee);

        i_USDC.safeTransferFrom(msg.sender, address(this), protocolFee);
        i_USDC.safeTransferFrom(msg.sender, address(i_sparkVault), _amount - protocolFee);
        i_sparkToken.mint(msg.sender, ((_amount * STANDART_DECIMALS) / USDC_DECIMALS) - ((protocolFee * STANDART_DECIMALS) / USDC_DECIMALS));
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
        if (athlete.isValidated == false) revert Spark_AthleteNotValidated(s_athletes[msg.sender].isValidated);
        if (s_sponsors[msg.sender].isValidated == false) revert Spark_VerifyYourProfileFirst(s_sponsors[msg.sender].isValidated);

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
        if (msg.sender != s_automationsForwarder) revert Spark_CallerNotAllowed();
        if (s_monthlyDrawAmount < 10 * USDC_DECIMALS) revert Spark_NotEnoughFunds();
        
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

    function setForwarder(address _forwarder) external {
        if(s_automationsForwarder != address(0)) revert Spark_AlreadyUpdated();
        s_automationsForwarder = _forwarder;
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

    /**
     * @notice Send a simple request
     * @param _args Array of bytes arguments, represented as hex strings
    */
    function _sendRequest(string[] memory _args, UserType _type) internal returns (bytes32 _requestId) {
        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(JS_CODE);
        if (_args.length > 0) req.setArgs(_args);

        _requestId = _sendRequest(
            req.encodeCBOR(),
            CLF_SUBSCRIPTION_ID,
            GAS_LIMIT,
            DON_ID
        );

        s_clfRequest[_requestId] = CLFRequest ({
            user: msg.sender,
            userType: _type
        });
    }

    /**
     * @notice Store latest result/error
     * @param _requestId The request ID, returned by sendRequest()
     * @param _response Aggregated response from the user code
     * @param _err Aggregated error from the user code or from the execution pipeline
     * Either response or error parameter will be set, but never both
     */
    function fulfillRequest(bytes32 _requestId, bytes memory _response, bytes memory _err) internal override {
        if (_err.length > ALLOWED){
            emit Spark_RequestFailed(_requestId);
        }
        
        uint256 isValidated = abi.decode(_response, (uint256));

        if(isValidated == ALLOWED){
            CLFRequest memory request = s_clfRequest[_requestId];

            if(request.userType == UserType.Athlete){
                s_athletes[request.user].isValidated = true;
            } else if (request.userType == UserType.Benefactor){
                s_benefactors[request.user].isValidated = true;
            } else if (request.userType == UserType.Sponsor){
                s_sponsors[request.user].isValidated = true;
            }
        }

        emit Spark_Response(_requestId, _response, _err);
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

    function _addressToString(address _addr) private pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint256 i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        return string(str);
    }

    /////////////////
    ///view & pure///
    /////////////////
    function getBenefactorInfo(address _benefactorAddress) external view returns(Benefactor memory _benefactor){
       _benefactor = s_benefactors[_benefactorAddress];
    }

    function getAthleteInfos(uint256 _athleteId) external view returns(Athlete memory athlete){
        address athleteAddress = s_athleteIdentification[_athleteId];

        athlete = s_athletes[athleteAddress];
    }

    function getSponsorInfo(uint256 _sponsorId) external view returns(Sponsors memory sponsors){
        address sponsorAddress = s_sponsorIdentification[_sponsorId];
        sponsors = s_sponsors[sponsorAddress];
    }

    function getCampaignInfos(uint256 _athleteId) external view returns(Campaing memory campaing){
        campaing = s_campaings[_athleteId];
    }


    function getRequestStatus(uint256 _requestId) external view returns (bool fulfilled, uint256 randomWords) {
        if(s_requests[_requestId].exists == false) revert Spark_RequestNotFound(_requestId);

        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }

    ////////// Delete After Testing ////////////
    function manuallyFulfillRequest(bytes32 _requestId, bytes memory _response, bytes memory _err) external {
        fulfillRequest(_requestId, _response, _err);
    }
}
