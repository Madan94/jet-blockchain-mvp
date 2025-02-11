const hre = require("hardhat");

async function main() {
  const cargotracking = await hre.ethers.getContractFactory("cargotracking");
  const cargoTracking = await cargotracking.deploy({
    gasLimit: 2000000,  
  });

  await cargoTracking.deployTransaction.wait();

  console.log(`✅ Contract deployed at: ${cargoTracking.address}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
