require("@nomicfoundation/hardhat-toolbox");
/** @type import('hardhat/config').HardhatUserConfig */
require("@truffle/dashboard-hardhat-plugin");
const ETHERSCAN_API_KEY="SOME_KEY"

module.exports = {
  solidity: "0.8.17",

  networks: {
    truffledashboard: {
      url: "http://localhost:24012/rpc"
    },
    optimisticGoerli: {
      // can be replaced with the RPC url of your choice.
      url: "https://goerli.optimism.io",
      accounts: [
          "SOME_PK"
      ],
    },
    optimisticEthereum: {
        url: "https://mainnet.optimism.io",
        accounts: [
            "SOME_PK"
        ],
    },
    mantle: {
      url: "https://rpc.testnet.mantle.xyz",
      accounts: [
        "SOME_PK"
      ],
    },
    scrollAlpha: {
      url: "https://alpha-rpc.scroll.io/l2",
      accounts: [
        "SOME_PK"
      ],
    }
  },
  etherscan: {
    apiKey: {
      linea: ETHERSCAN_API_KEY,
      optimisticGoerli: "SOME_KEY",
      optimisticEthereum: "SOME_KEY",
      scrollAlpha: "SOME_KEY"
    },
    customChains: [
      {
        network: 'scrollAlpha',
        chainId: 534353,
        urls: {
          apiURL: 'https://blockscout.scroll.io/api',
          browserURL: 'https://blockscout.scroll.io/',
        },
      }
    ]
  }
};
