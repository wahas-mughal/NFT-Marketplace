const assert = require("chai");

//bring in the artifacts
const KryptoBird = artifacts.require("./Kryptobird");

// check for chai
require("chai")
  .use(require("chai-as-promised"))
  .should();
