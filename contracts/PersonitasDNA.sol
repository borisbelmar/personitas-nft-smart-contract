// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract PersonitasDNA {
  string[] private _accessoriesType = [
    "Blank",
    "Kurt",
    "Prescription01",
    "Prescription02",
    "Round",
    "Sunglasses",
    "Wayfarers"
  ];

  string[] private _clotheColor = [
    "Black",
    "Blue01",
    "Blue02",
    "Blue03",
    "Gray01",
    "Gray02",
    "Heather",
    "PastelBlue",
    "PastelGreen",
    "PastelOrange",
    "PastelRed",
    "PastelYellow",
    "Pink",
    "Red",
    "White"
  ];

  string[] private _clotheType = [
    "BlazerShirt",
    "BlazerSweater",
    "CollarSweater",
    "GraphicShirt",
    "Hoodie",
    "Overall",
    "ShirtCrewNeck",
    "ShirtScoopNeck",
    "ShirtVNeck"
  ];

  string[] private _eyeType = [
    "Close",
    "Cry",
    "Default",
    "Dizzy",
    "EyeRoll",
    "Happy",
    "Hearts",
    "Side",
    "Squint",
    "Surprised",
    "Wink",
    "WinkWacky"
  ];

  string[] private _eyebrowType = [
    "Angry",
    "AngryNatural",
    "Default",
    "DefaultNatural",
    "FlatNatural",
    "RaisedExcited",
    "RaisedExcitedNatural",
    "SadConcerned",
    "SadConcernedNatural",
    "UnibrowNatural",
    "UpDown",
    "UpDownNatural"
  ];

  string[] private _facialHairColor = [
    "Auburn",
    "Black",
    "Blonde",
    "BlondeGolden",
    "Brown",
    "BrownDark",
    "Platinum",
    "Red"
  ];

  string[] private _facialHairType = [
    "Blank",
    "BeardMedium",
    "BeardLight",
    "BeardMagestic",
    "MoustacheFancy",
    "MoustacheMagnum"
  ];

  string[] private _hairColor = [
    "Auburn",
    "Black",
    "Blonde",
    "BlondeGolden",
    "Brown",
    "BrownDark",
    "PastelPink",
    "Platinum",
    "Red",
    "SilverGray"
  ];

  string[] private _hatColor = [
    "Black",
    "Blue01",
    "Blue02",
    "Blue03",
    "Gray01",
    "Gray02",
    "Heather",
    "PastelBlue",
    "PastelGreen",
    "PastelOrange",
    "PastelRed",
    "PastelYellow",
    "Pink",
    "Red",
    "White"
  ];

  string[] private _graphicType = [
    "Bat",
    "Cumbia",
    "Deer",
    "Diamond",
    "Hola",
    "Pizza",
    "Resist",
    "Selena",
    "Bear",
    "SkullOutline",
    "Skull"
  ];

  string[] private _mouthType = [
    "Concerned",
    "Default",
    "Disbelief",
    "Eating",
    "Grimace",
    "Sad",
    "ScreamOpen",
    "Serious",
    "Smile",
    "Tongue",
    "Twinkle",
    "Vomit"
  ];

  string[] private _skinColor = [
    "Tanned",
    "Yellow",
    "Pale",
    "Light",
    "Brown",
    "DarkBrown",
    "Black"
  ];

  string[] private _topType = [
    "NoHair",
    "Eyepatch",
    "Hat",
    "Hijab",
    "Turban",
    "WinterHat1",
    "WinterHat2",
    "WinterHat3",
    "WinterHat4",
    "LongHairBigHair",
    "LongHairBob",
    "LongHairBun",
    "LongHairCurly",
    "LongHairCurvy",
    "LongHairDreads",
    "LongHairFrida",
    "LongHairFro",
    "LongHairFroBand",
    "LongHairNotTooLong",
    "LongHairShavedSides",
    "LongHairMiaWallace",
    "LongHairStraight",
    "LongHairStraight2",
    "LongHairStraightStrand",
    "ShortHairDreads01",
    "ShortHairDreads02",
    "ShortHairFrizzle",
    "ShortHairShaggyMullet",
    "ShortHairShortCurly",
    "ShortHairShortFlat",
    "ShortHairShortRound",
    "ShortHairShortWaved",
    "ShortHairSides",
    "ShortHairTheCaesar",
    "ShortHairTheCaesarSidePart"
  ];

  // Not suitable for production! Use Chainlink or an oracle to generate a random value.
  function deterministicPseudoRandomDNA(uint256 _tokenId, address _minter) public pure returns(uint256) {
    uint256 combinedParams = _tokenId + uint160(_minter);
    bytes memory encodedParams = abi.encodePacked(combinedParams);
    bytes32 hashedParams = keccak256(encodedParams);

    return uint256(hashedParams);
  }

  // Get attributes
  uint8 constant ADN_SECTION_SIZE = 2;

  function _getDNASection (uint256 _dna, uint8 _rightDiscard) internal pure returns (uint8) {
    return uint8(
      (_dna % 1 * 10 ** (_rightDiscard + ADN_SECTION_SIZE)) / (1 * 10 ** _rightDiscard)
    );
  }

  function _getItem(string[] memory _items, uint256 _dna, uint8 _section) internal pure returns (string memory) {
    uint8 dnaSection = _getDNASection(_dna, _section);
    return _items[dnaSection % _items.length];
  }

  function getAccessoriesType(uint _dna) public view returns(string memory) {
    return _getItem(_accessoriesType, _dna, 0);
  }

  function getClotheColor(uint _dna) public view returns(string memory) {
    return _getItem(_clotheColor, _dna, 2);
  }

  function getClotheType(uint _dna) public view returns(string memory) {
    return _getItem(_clotheType, _dna, 4);
  }

  function getEyeType(uint _dna) public view returns(string memory) {
    return _getItem(_eyeType, _dna, 6);
  }

  function getEyeBrowType(uint _dna) public view returns(string memory) {
    return _getItem(_eyebrowType, _dna, 8);
  }

  function getFacialHairColor(uint _dna) public view returns(string memory) {
    return _getItem(_facialHairColor, _dna, 10);
  }

  function getFacialHairType(uint _dna) public view returns(string memory) {
    return _getItem(_facialHairType, _dna, 12);
  }

  function getHairColor(uint _dna) public view returns(string memory) {
    return _getItem(_hairColor, _dna, 14);
  }

  function getHatColor(uint _dna) public view returns(string memory) {
    return _getItem(_hatColor, _dna, 16);
  }

  function getGraphicType(uint _dna) public view returns(string memory) {
    return _getItem(_graphicType, _dna, 18);
  }

  function getMouthType(uint _dna) public view returns(string memory) {
    return _getItem(_mouthType, _dna, 20);
  }

  function getSkinColor(uint _dna) public view returns(string memory) {
    return _getItem(_skinColor, _dna, 22);
  }

  function getTopType(uint _dna) public view returns(string memory) {
    return _getItem(_topType, _dna, 24);
  }
}