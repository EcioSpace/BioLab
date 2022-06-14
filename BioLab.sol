//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./CreatePartcode.sol";
import "./Helper.sol";

interface ECIOERC721 {
    function tokenInfo(uint256 _tokenId)
        external
        view
        returns (string memory, uint256);

    function safeMint(address to, string memory partCode) external;
}

interface RANDOM_CONTRACT {
    function startRandom() external returns (uint256);
}

contract BioLab is Ownable, ECIOHelper,RandomPartcode {
    struct Info {
        string partCode;
        uint256 createAt;
    }
    address public nftCoreContract;
    address public ecioTokenContract;
    address public lakrimaTokenContract;
    address public randomWorkerContract;

    uint16 public ratePerFragment;

    uint256 randomNumber;

    uint256 public ecioPrice = 10000 * 10**18;
    uint256 public lakrimaPrice = 25000 * 10**18;

    // Fragment[] fragments;

    //Setup
    function updateNFTsContract(address _address) public onlyOwner {
        nftCoreContract = _address;
    }

    function changeEcioTokenContract(address _address) public onlyOwner {
        ecioTokenContract = _address;
    }

    function changeLakrimaTokenContract(address _address) public onlyOwner {
        lakrimaTokenContract = _address;
    }

    function updateRandomWorkerContract(address _address) public onlyOwner {
        randomWorkerContract = _address;
    }



    function updateLakrimaPrice(uint256 price) public onlyOwner {
        lakrimaPrice = price;
    }

    function updateEcioPrice(uint256 price) public onlyOwner {
        ecioPrice = price;
    }

    function setRatePerFragment(uint16 rate) public onlyOwner {
        ratePerFragment = rate;
    }

    
    function bioLabMerge(
        uint256[] memory tokenIds
    ) public returns (bool success) {
        
        uint256 _balanceEcio = IERC20(ecioTokenContract).balanceOf(msg.sender);
        require(
            _balanceEcio >= ecioPrice * tokenIds.length,
            "ECIO: Your balance is insufficient."
        );
        uint256 _balanceLakrima = IERC20(lakrimaTokenContract).balanceOf(
            msg.sender
        );
        require(
            _balanceLakrima >= lakrimaPrice * tokenIds.length,
            "LAKRIMA: Your balance is insufficient."
        );
        string memory firstPartCode;
        for (uint256 index = 0; index < tokenIds.length; index++) {
            // address owner = ERC721(nftCoreContract).ownerOf(tokenIds[index]);
            require(
                ERC721(nftCoreContract).ownerOf(tokenIds[index]) == msg.sender,
                "You are not owner."
            );
            string memory partCode = getPartInfo(tokenIds[index]);
            if (index != 0) {
                require(
                    keccak256(bytes(firstPartCode)) ==
                        keccak256(bytes(partCode)),
                    "Please use same fragment to forge."
                );
            } else {
                firstPartCode = partCode;
            }
            ERC721(nftCoreContract).transferFrom(
                msg.sender,
                address(this),
                tokenIds[index]
            );
            if (index == tokenIds.length - 1) {
                IERC20(ecioTokenContract).transferFrom(
                    msg.sender,
                    address(this),
                    ecioPrice * tokenIds.length
                );
                IERC20(lakrimaTokenContract).transferFrom(
                    msg.sender,
                    address(this),
                    lakrimaPrice * tokenIds.length
                );
                uint16 rate = uint16(tokenIds.length) * ratePerFragment;
                randomNumber=RANDOM_CONTRACT(randomWorkerContract)
                        .startRandom();
                string memory genPart=getGeneticInfo(firstPartCode);
                uint8 rarity=getRarityInfo(genPart);
                
                if (rate >= 100) {     
                    string memory newWarriorPartCode =createPartCode(randomNumber,rarity);
                    ECIOERC721(nftCoreContract).safeMint(
                        msg.sender,
                        newWarriorPartCode
                    );
                    return true;
                } else {
                    uint256 randomSuccessNumber = RANDOM_CONTRACT(randomWorkerContract)
                        .startRandom();
                    

                    uint16 randomResult = getNumberAndMod(randomSuccessNumber, 5, 100);
                    if (rate > randomResult) {
                        // partCodeCheck
                    string memory newWarriorPartCode =createPartCode(randomNumber,rarity);
                    ECIOERC721(nftCoreContract).safeMint(
                        msg.sender,
                        newWarriorPartCode
                    );
                        return true;
                    } else {
                        return false;
                    }
                }
            }
        }
    }

    function compareStrings(string memory a, string memory b)
        public
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }


    function getRarityInfo(string memory genInfo)public pure returns (uint8){
        if(compareStrings(genInfo,"00") || compareStrings(genInfo,"01") ||compareStrings(genInfo,"02") || compareStrings(genInfo,"03") ||compareStrings(genInfo,"04") ||compareStrings(genInfo,"05")||compareStrings(genInfo,"06"))
            return 0;
        else if(compareStrings(genInfo,"07")||compareStrings(genInfo,"08")||compareStrings(genInfo,"09")||compareStrings(genInfo,"10")||compareStrings(genInfo,"11")||compareStrings(genInfo,"12"))
            return 1;
        else if(compareStrings(genInfo,"13")|| compareStrings(genInfo,"14")||compareStrings(genInfo,"15")||compareStrings(genInfo,"16"))
            return 2;
        else if(compareStrings(genInfo,"17")|| compareStrings(genInfo,"18")||compareStrings(genInfo,"19"))
            return 3;
        else return 4;
    }

    function getGeneticInfo(string memory partCode)public view returns(string memory){
            string memory geneticInfo=string(
                abi.encodePacked(
                    bytes(partCode)[10],
                    bytes(partCode)[11]
                )
            );
            return geneticInfo;
    }

    function getPartInfo(uint256 tokenId)public view returns (string memory) {
        Info memory tokenInfo;
        (tokenInfo.partCode, tokenInfo.createAt) = ECIOERC721(nftCoreContract)
            .tokenInfo(tokenId);
        return tokenInfo.partCode;
    }
    function transferFee(
        address _contractAddress,
        address _to,
        uint256 _amount
    ) public onlyOwner {
        IERC20 _token = IERC20(_contractAddress);
        _token.transfer(_to, _amount);
    }

   
}