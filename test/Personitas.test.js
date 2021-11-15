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

    expect(returnedMaxSupply).to.equal(maxSupply);
    expect(returnedMintingPrice).to.equal(mintingPrice);
  })
})

describe('Personitas NFT Minting', () => {
  it('Mints a new token and assigns it to owner', async () => {
    const { owner, deployed } = await setup();

    await deployed.mint({ value: 300000000000000 });

    const ownerOfMinted = await deployed.ownerOf(0);
    
    expect(ownerOfMinted).to.equal(owner.address);
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
})