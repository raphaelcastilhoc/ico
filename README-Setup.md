# Setup

## Project Setup

Install (if needed) and switch to `node` version specified in `.nvmrc` file:

```bash
nvm install
```

Install all needed dependencies:

```bash
npm install
```

Ensure your project is setup correctly by running:

```bash
npx hardhat compile
```

Now you're all setup to begin writing tests and smart contracts! Check out the `package.json`'s scripts section for useful commands

## Useful Commands

Try running some of the following commands:

```shell
npx hardhat help
npx hardhat compile              # compile your contracts
npx hardhat test                 # run your tests
npm run test                     # watch for test file changes and automatically run tests
npx hardhat coverage             # generate a test coverage report at coverage/index.html
REPORT_GAS=true npx hardhat test # run your tests and output gas usage metrics
npx hardhat node                 # spin up a fresh in-memory instance of the Ethereum blockchain
npx prettier '**/*.{json,sol,md,ts,js}' --write # format your Solidity and TS files
```
