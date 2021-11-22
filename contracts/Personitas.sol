// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";
import "./PersonitasDNA.sol";

contract Personitas is ERC721, ERC721Enumerable, Ownable, PersonitasDNA {
  using Counters for Counters.Counter;
  using Strings for uint256;

  Counters.Counter private _idCounter;
  uint256 public maxSupply;
  uint256 public mintingPrice;
  mapping(uint256 => uint256) public tokenDNA;

  constructor(uint256 _maxSupply, uint256 _mintingPrice) ERC721("Personitas", "PRS") {
    maxSupply = _maxSupply;
    mintingPrice = _mintingPrice;
  }

  function mint() public payable {
    uint256 current = _idCounter.current();
    require(current < maxSupply, "Not Personitas Lefts :(");
    require(msg.value >= mintingPrice, "Not enought money");

    payable(owner()).transfer(mintingPrice);

    // TODO: Use an oracle like Chainlink for production!
    tokenDNA[current] = deterministicPseudoRandomDNA(current, msg.sender);

    _safeMint(msg.sender, current);
    _idCounter.increment();
  }

   function getSupplyLeft() public view returns(uint256) {
    return maxSupply - _idCounter.current();
  }


  function _baseURI() internal pure override returns (string memory) {
    return "https://avataaars.io/";
  }


  function _paramsURI(uint256 _dna) internal view returns (string memory) {
    string memory params = string(abi.encodePacked(
      "accessoriesType=",
      getAccessoriesType(_dna),
      "&clotheColor=",
      getClotheColor(_dna),
      "&clotheType=",
      getClotheType(_dna),
      "&eyeType=",
      getEyeType(_dna),
      "&eyebrowType=",
      getEyeBrowType(_dna),
      "&facialHairColor=",
      getFacialHairColor(_dna),
      "&facialHairType=",
      getFacialHairType(_dna),
      "&hairColor=",
      getHairColor(_dna),
      "&hatColor=",
      getHatColor(_dna),
      "&graphicType=",
      getGraphicType(_dna),
      "&mouthType=",
      getMouthType(_dna),
      "&skinColor=",
      getSkinColor(_dna)
    ));
    // @dev This is appart avoiding the stak overflow
    return string(abi.encodePacked(
      params,
      "&topType=",
      getTopType(_dna)
    ));
  }

  function imageByDNA(uint256 _dna) public view returns (string memory) {
    string memory params = _paramsURI(_dna);
    string memory base = _baseURI();
    return string(abi.encodePacked(base, "?", params));
  }

  // Override
  function tokenURI(uint256 _tokenId) override public view returns(string memory) {
    require(_exists(_tokenId), "Invalid token id");
    uint256 dna = tokenDNA[_tokenId];
    string memory imageURI = imageByDNA(dna);

    string memory jsonURI = Base64.encode(abi.encodePacked(
      '{"name": "Personita #',
      _tokenId.toString(),
      '", "description": "Personitas are randomly generated characters", "image": "',
      imageURI,
      '"}'
    ));
    return string(abi.encodePacked("data:application/json;base64,", jsonURI));
  }

  // The following functions are overrides required by Solidity.
  function _beforeTokenTransfer(address from, address to, uint256 tokenId)
    internal
    override(ERC721, ERC721Enumerable)
  {
    super._beforeTokenTransfer(from, to, tokenId);
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }
}