import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from "../abis/KryptoBird.json";
import {
  MDBCard,
  MDBCardBody,
  MDBCardTitle,
  MDBCardText,
  MDBCardImage,
  MDBBtn,
  MDBRipple,
} from "mdb-react-ui-kit";
import "./App.css";

export default class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      account: "",
      contract: null,
      totalSupply: 0,
      KryptoBirds: [],
    };
  }

  async componentDidMount() {
    await this.loadWeb3();
    await this.loadBlockchainData();
  }

  //connect browser to web3
  async loadWeb3() {
    const provider = await detectEthereumProvider();

    if (provider) {
      console.log("ETH is connected successfully!");
      Window.web3 = new Web3(provider);
    } else {
      console.log("ETH is not connected.Failed!");
    }
  }

  //load blockchain data
  async loadBlockchainData() {
    const web3 = Window.web3;
    const accounts = await web3.eth.getAccounts();
    this.setState({ account: accounts[0] });

    //get the blockchain network id
    const networkId = await web3.eth.net.getId();
    //get the network data
    const networkData = KryptoBird.networks[networkId];
    //check to see if the network data is available.

    if (networkData) {
      const abi = KryptoBird.abi;
      const address = networkData.address;
      const contract = new web3.eth.Contract(abi, address);
      this.setState({ contract: contract });

      //get the total supply
      const totalSupply = await contract.methods.totalSupply().call();
      this.setState({ totalSupply });
      console.log("TOTAL SUPPLY ", this.state.totalSupply);
      //keep track of KryptoBirds and totalSupply
      for (let i = 1; i <= totalSupply; i++) {
        const KryptoBird = await contract.methods.kryptoBirds(i - 1).call();
        this.setState({
          KryptoBirds: [...this.state.KryptoBirds, KryptoBird],
        });
      }
      console.log(this.state.KryptoBirds);
    } else {
      console.log("No network data");
    }
  }

  //minting function to mint the NFT

  //another of writing function
  mint = async (KryptoBirdz) => {
    if (KryptoBirdz == "") {
      return;
    } else {
      await this.state.contract.methods
        .mint(KryptoBirdz)
        .send({ from: this.state.account })
        .once("receipt", (receipt) => {
          this.setState({
            KryptoBirds: [...this.state.KryptoBirds, KryptoBirdz],
          });
        });
    }
  };

  render() {
    return (
      <div>
        <nav className="navbar navbar-expand-lg navbar-light bg-light">
          <a className="navbar-brand" href="#">
            KryptoParrots
          </a>

          <button
            className="navbar-toggler"
            type="button"
            data-toggle="collapse"
            data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent"
            aria-expanded="false"
            aria-label="Toggle navigation"
          >
            <span className="navbar-toggler-icon"></span>
          </button>

          <div className="collapse navbar-collapse" id="navbarSupportedContent">
            <ul className="navbar-nav mr-auto">
              <li className="nav-item active">
                <a className="nav-link" href="#">
                  Home <span className="sr-only">(current)</span>
                </a>
              </li>
              <li className="nav-item">
                <a className="nav-link" href="#">
                  NFTs
                </a>
              </li>
            </ul>
            <form className="form-inline my-2 my-lg-0">
              <input
                className="form-control mr-sm-2"
                type="text"
                placeholder="Search"
                aria-label="Search"
              />
              <button
                className="btn btn-outline-success my-2 my-sm-0"
                type="submit"
              >
                Search
              </button>
            </form>
          </div>
        </nav>
        <div className="row d-flex justify-content-center flex-nowrap ml-2 mt-4 mb-4">
          <h1 style={{ color: "#fff" }}> KryptoParrots NFT Marketplace</h1>
        </div>
        <div className="row mt-3 ml-3 ">
          <div className="card col-5 mr-3 ">
            <div className="card-body">
              <h4 className="card-title"> Account Address </h4>
              <p className="card-text">{this.state.account}</p>
            </div>
          </div>
          <div className="card col-5 p-3">
            <form
              className="mx-auto my-auto"
              onSubmit={(e) => {
                e.preventDefault();
                const kryptoBirds = this.kryptoBirds.value;
                this.mint(kryptoBirds);
              }}
            >
              <div className="form-group">
                <label htmlFor="formGroupExampleInput">File Location</label>
                <input
                  type="text"
                  ref={(input) => (this.kryptoBirds = input)}
                  className="form-control"
                  id="formGroupExampleInput"
                  placeholder="Add a file location"
                />
              </div>
              <button type="submit" className="btn btn-success">
                Mint
              </button>
            </form>
          </div>
        </div>
        <div className="row mt-3 mb-3 ml-3">
          {this.state.KryptoBirds.map((items, index) => (
            <div className="mr-3 mt-3" key={index}>
              <MDBCard style={{ maxWidth: "19rem" }} className="token">
                <MDBCardImage
                  src={items}
                  fluid
                  alt="Krypto Parrot"
                  style={{ width: "100%", height: "12rem" }}
                />
                <a>
                  <div
                    className="mask"
                    style={{ backgroundColor: "rgba(251, 251, 251, 0.15)" }}
                  ></div>
                </a>
                <MDBCardBody>
                  <MDBCardTitle>Krypto Parrot</MDBCardTitle>
                  <MDBCardText>
                    We are the KryptoParrots - the underground anti-heroes of a
                    not so distant dystopian galaxy. We are all caught in a
                    shadow war of machines and birds, awake or asleep. Please
                    help us save the meta-verse from the Evil Empire of Big
                    Institutional Oblivion.
                  </MDBCardText>
                  <MDBBtn href="#">Download</MDBBtn>
                </MDBCardBody>
              </MDBCard>
            </div>
          ))}
        </div>
      </div>
    );
  }
}
