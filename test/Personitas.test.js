const { expect } = require('chai');

const setup = async ({ maxSupply = 10000, mintingPrice = 300000000000000 } = {}) => {
  const [owner] = await ethers.getSigners();
  const Personitas = await ethers.getContractFactory("Personitas");
  const deployed = await Personitas.deploy(maxSupply, mintingPrice);

  return {
    owner,
    deployed
  }
}

describe('Personitas NFT Deploy', () => {
  it('Testing constructor', async () => {
    const maxSupply = 4000;
    const mintingPrice = 10000;

    const { deployed } = await setup({ maxSupply, mintingPrice });

    const returnedMaxSupply = await deployed.maxSupply();
    const returnedMintingPrice = await deployed.mintingPrice();
    const currentSupply = await deployed.totalSupply();

    expect(returnedMaxSupply).to.equal(maxSupply);
    expect(returnedMintingPrice).to.equal(mintingPrice);
    expect(currentSupply).to.equal(0);
  })
})

describe('Personitas NFT Minting', () => {
  it('Mints a new token and assigns it to owner', async () => {
    const { owner, deployed } = await setup();

    await deployed.mint({ value: 300000000000000 });

    const ownerOfMinted = await deployed.ownerOf(0);
    
    expect(ownerOfMinted).to.equal(owner.address);
  })

  it('Show correct current supply and left supply', async () => {
    const maxSupply = 100;
    const { deployed } = await setup({ maxSupply });

    await Promise.all([
      deployed.mint({ value: 300000000000000 }),
      deployed.mint({ value: 300000000000000 })
    ])

    const currentSupply = await deployed.totalSupply();
    const supplyLeft = await deployed.getSupplyLeft();

    expect(currentSupply).to.equal(2);
    expect(supplyLeft).to.equal(maxSupply - 2);
  })

  it('Has mint limit', async () => {
    const maxSupply = 2;

    const { deployed } = await setup({ maxSupply });

    await Promise.all([
      deployed.mint({ value: 300000000000000 }),
      deployed.mint({ value: 300000000000000 })
    ])

    await expect(deployed.mint({ value: 300000000000000 })).to.be.revertedWith('Not Personitas Lefts :(');
  })

  it('Pay for minting', async () => {
    const mintingPrice = 100;

    const { deployed } = await setup({ mintingPrice });

    await deployed.mint({ value: 100 })
    await expect(deployed.mint({ value: 99 })).to.be.revertedWith('Not enought money');
  })
})

describe('Personitas Token URI', () => {
  it('Return valid metadata', async () => {
    const { deployed } = await setup();

    await deployed.mint({ value: 300000000000000 });

    const tokenURI = await deployed.tokenURI(0);
    const stringifiedTokenURI = await tokenURI.toString();

    const [,base64JSON] = stringifiedTokenURI.split('data:application/json;base64,');
    const stringifiedMetadata = Buffer.from(base64JSON, 'base64').toString('ascii')
    
    const metadata = JSON.parse(stringifiedMetadata);

    expect(metadata).to.have.all.keys('name', 'description', 'image');
  })

  it('Images and DNA are unique by address and id', async () => {
    const { deployed } = await setup();

    await Promise.all([
      deployed.mint({ value: 300000000000000 }),
      deployed.mint({ value: 300000000000000 })
    ])

    const [dna0, dna1] = await Promise.all([
      deployed.tokenDNA(0),
      deployed.tokenDNA(1)
    ])

    expect(dna0).to.not.equal(dna1);

    const [image0, image1] = await Promise.all([
      deployed.imageByDNA(dna0),
      deployed.imageByDNA(dna1)
    ])

    expect(image0).to.not.equal(image1);
  })
})