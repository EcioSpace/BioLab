// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract RandomPartcode is Ownable {
    using Strings for string;
    uint8 private constant NFT_TYPE = 0; //Kingdom

    uint8 private constant SUITE = 5; //Battle Suit
    uint8 private constant WEAP = 8; //WEAP
    uint8 private constant SPACE_WARRIOR = 6;


    uint8 private constant COMMON = 0;
    uint8 private constant RARE = 1;
    uint8 private constant EPIC = 2;
    uint8 private constant LEGENDARY = 3;
    uint8 private constant LIMITED=4;

    // mapping(uint8=>mapping(uint8=>uint8)) public Weapon;
    uint8 [][4] public Weapon;
    uint8 [][4] public Battle_Bot;
    uint8 [][4] public Battle_Suite;
    uint8 [][4] public Battle_Drone;
    uint8 [][4] public Battle_Gear;
    uint8 [5] public Training_Camp;


    constructor() {
        Weapon[COMMON]=[0,1,2,3];
        Weapon[RARE]=[4,5,6,7,8];
        Weapon[EPIC]=[9,10,11,12,13,14];
        Weapon[LEGENDARY]=[15,16,17,18,19];

        Battle_Bot[COMMON]=[0,1,2,3,4];
        Battle_Bot[RARE]=[0,5,6,7];
        Battle_Bot[EPIC]=[0,8,9,10];
        Battle_Bot[LEGENDARY]=[0,11,12];

        Battle_Suite[COMMON]=[0,1,2];
        Battle_Suite[RARE]=[3,4,5];
        Battle_Suite[EPIC]=[6,7,8,9];
        Battle_Suite[LEGENDARY]=[10,11];

        Battle_Drone[COMMON]=[0,1,2,3,4];
        Battle_Drone[RARE]=[0,5,6,7];
        Battle_Drone[EPIC]=[0,8,9,10];
        Battle_Drone[LEGENDARY]=[0,11,12];

        Battle_Gear[COMMON]=[0,1,2,3,4];
        Battle_Gear[RARE]=[0,5,6,7];
        Battle_Gear[EPIC]=[0,8,9,10];
        Battle_Gear[LEGENDARY]=[0,11,12];

        Training_Camp=[0,1,2,3,4];
        
    }
 
    function getNumberAndMod(
        uint256 _ranNum,
        uint16 digit,
        uint256 mod
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

    function getPartId(uint256 _randomNumber,uint16 digit, uint8[] memory  partArray) public returns( uint8){
        uint256 arrayLength=partArray.length;
        uint256 index=getNumberAndMod(_randomNumber,digit,arrayLength);
        return partArray[index];
    }

    function createPartCode(uint256 _randomNumber, uint8 rarity)
        public
        returns (string memory)
        {    
        uint8 weapon_Id=getPartId(_randomNumber,3,Weapon[rarity]);
        uint8 bot_Id=getPartId(_randomNumber,4,Battle_Bot[rarity]);
        uint8 suite_Id=getPartId(_randomNumber,5,Battle_Suite[rarity]);
        uint8 drone_Id=getPartId(_randomNumber,6,Battle_Drone[rarity]);
        uint8 gear_Id=getPartId(_randomNumber,7,Battle_Gear[rarity]);
        // uint8 camp_Id=getPartId(_randomNumber,8,Training_Camp);


        // adjust digit to random partcode     
        string memory concatedCode = "";
        concatedCode = concateCode(concatedCode, 0); //kingdomCode
        concatedCode = concateCode(concatedCode, 0);
        concatedCode = concateCode(concatedCode, 0);
        concatedCode = concateCode(concatedCode, 0);
        concatedCode = concateCode(concatedCode,weapon_Id);
        concatedCode = concateCode(concatedCode,rarity);
        concatedCode = concateCode(concatedCode,bot_Id);
        concatedCode = concateCode(concatedCode,suite_Id);
        concatedCode = concateCode(concatedCode,drone_Id);
        concatedCode = concateCode(concatedCode,gear_Id);
        concatedCode = concateCode(concatedCode,0);  
        concatedCode = concateCode(concatedCode, 0); //Reserved
        concatedCode = concateCode(concatedCode, 0); //Reserved
        return concatedCode;
    }


    function concateCode(string memory concatedCode, uint8 digit)
        public
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
