const hre = require("hardhat");

async function main() {
  // Deploy TokenA
  const TokenA = await hre.ethers.getContractFactory("TokenA");
  const tokenA = await TokenA.deploy();
  console.log("TokenA deployed to:", tokenA.target);

  // Deploy TokenB
  const TokenB = await hre.ethers.getContractFactory("TokenB");
  const tokenB = await TokenB.deploy();
  console.log("TokenB deployed to:", tokenB.target);

  // Deploy TokenSwap
  const TokenSwap = await hre.ethers.getContractFactory("TokenSwap");
  const tokenSwap = await TokenSwap.deploy();
  console.log("TokenSwap deployed to:", tokenSwap.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});