const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying contracts with the account:", deployer.address);
  
    console.log("Account balance:", (await deployer.getBalance()).toString());
    // Deploy the Voting contract
    const Contract = await ethers.getContractFactory("ProposalVoting");
    const contract = await Contract.deploy('0x4200000000000000000000000000000000000007');
    await contract.deployed();
    console.log("Contract deployed to:", contract.address);

  console.log("Voting completed!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
