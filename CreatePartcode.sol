// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


interface ERC721_CONTRACT {
    function safeMint(address to, string memory partCode) external;
}

interface RANDOM_CONTRACT {
    function startRandom() external returns (uint256);
}

interface RANDOM_PARTRATE {
    function getGenPool(
        uint16 _rarity,
        uint16 _number
    ) external view returns (uint16);

    function getNFTPool(uint16 _number)
        external
        view
        returns (uint16);

    function getEquipmentPool(uint16 _number) external view returns (uint16);

    function getBlueprintPool(
        uint16 _rarity,
        uint16 eTypeId,
        uint16 _number
    ) external view returns (uint16);

    function getSpaceWarriorPool(
        uint16 _part,
        uint16 _number
    ) external view returns (uint16);
}

contract RandomPartcode is Ownable {
    using Strings for string;
    uint8 private constant NFT_TYPE = 0; //Kingdom

    uint8 private constant SUITE = 5; //Battle Suit
    uint8 private constant WEAP = 8; //WEAP
    uint8 private constant SPACE_WARRIOR = 6;
    uint8 private constant GEN = 7; //Human GEN

    uint8 private constant COMMON = 0;
    uint8 private constant RARE = 1;
    uint8 private constant EPIC = 2;
    uint8 private constant SPACIAL = 3;

    address public nftCoreContract;
    address public randomWorkerContract;
    enum randomRateType{
        STD
    }
    mapping(randomRateType => address) public randomRateAddress;     

    constructor() {}

    function changeRandomWorkerContract(address _address) public onlyOwner {
        randomWorkerContract = _address;
    }

    function changeNftCoreContract(address _address) public onlyOwner {
        nftCoreContract = _address;
    }

    //Change RandomRate type Contract

    function changeRandomRateSTD(address _address) public onlyOwner {
        randomRateAddress[randomRateType.STD] = _address;
    }


    function createNFTCode()
        internal
        
        returns (string memory)
    {
        string memory partCode;
         uint256 _randomNumber = RANDOM_CONTRACT(randomWorkerContract)
          .startRandom();
        //create SW
        partCode = createSW(_randomNumber,randomRateType.STD);

        return partCode;
    }

    function getNumberAndMod(
        uint256 _ranNum,
        uint16 digit,
        uint16 mod
    ) public view virtual returns (uint16) {
        if (digit == 1) {
            return uint16((_ranNum % 10000) % mod);
        } else if (digit == 2) {
            return uint16(((_ranNum % 100000000) / 10000) % mod);
        } else if (digit == 3) {
            return uint16(((_ranNum % 1000000000000) / 100000000) % mod);
        } else if (digit == 4) {
            return uint16(((_ranNum % 10000000000000000) / 1000000000000) % mod);
        } else if (digit == 5) {
            return uint16(((_ranNum % 100000000000000000000) / 10000000000000000) % mod);
        } else if (digit == 6) {
            return uint16(((_ranNum % 1000000000000000000000000) / 100000000000000000000) % mod);
        } else if (digit == 7) {
            return uint16(((_ranNum % 10000000000000000000000000000) / 1000000000000000000000000) % mod);
        } else if (digit == 8) {
            return uint16(((_ranNum % 100000000000000000000000000000000) / 10000000000000000000000000000) % mod);
        }

        return 0;
    }


    function createSW(uint256 _randomNumber, randomRateType _RandomType)
        private
        view
        returns (string memory)
        {
        

        
        // adjust digit to random partcode
        uint16 battleSuiteId = getNumberAndMod(_randomNumber, 5, 1000);
        uint16 humanGenomeId = getNumberAndMod(_randomNumber, 7, 1000);
        uint16 weaponId = getNumberAndMod(_randomNumber, 8, 1000);

        string memory concatedCode = convertCodeToStr(6);

        concatedCode = concateCode(concatedCode, 0); //kingdomCode
        concatedCode = concateCode(concatedCode, 0);
        concatedCode = concateCode(concatedCode, 0);
        concatedCode = concateCode(concatedCode, 0);
        concatedCode = concateCode(
            concatedCode,
            RANDOM_PARTRATE(randomRateAddress[_RandomType]).getSpaceWarriorPool(SUITE, battleSuiteId)
        );
        concatedCode = concateCode(concatedCode, 0);
        concatedCode = concateCode(
            concatedCode,
            RANDOM_PARTRATE(randomRateAddress[_RandomType]).getSpaceWarriorPool(GEN, humanGenomeId)
        );
        concatedCode = concateCode(
            concatedCode,
            RANDOM_PARTRATE(randomRateAddress[_RandomType]).getSpaceWarriorPool(WEAP, weaponId)
        );
        concatedCode = concateCode(concatedCode, 0); //Star
        concatedCode = concateCode(concatedCode, 0); //equipmentCode
        concatedCode = concateCode(concatedCode, 0); //Reserved
        concatedCode = concateCode(concatedCode, 0); //Reserved
        return concatedCode;
    }


    function concateCode(string memory concatedCode, uint256 digit)
        internal
        pure
        returns (string memory)
    {
        concatedCode = string(
            abi.encodePacked(convertCodeToStr(digit), concatedCode)
        );

        return concatedCode;
    }

    function convertCodeToStr(uint256 code)
        private
        pure
        returns (string memory)
    {
        if (code <= 9) {
            return string(abi.encodePacked("0", Strings.toString(code)));
        }

        return Strings.toString(code);
    }
}