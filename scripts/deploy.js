const deploy = async () => {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying the contract with account", deployer.address);

  const Personitas = await ethers.getContractFactory("Personitas");

  const deployed = await Personitas.deploy(1000, 300000000000000);

  console.log("Personitas has been deployed at: ", deployed.address);
};

deploy()
  .then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1)
  });