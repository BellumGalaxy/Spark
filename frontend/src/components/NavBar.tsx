import { useState } from "react";
import "../styles/NavBar.css";
import SparkLogo from "../assets/logo-spark.png";
import { ConnectButton } from "thirdweb/react";
import { client } from "../utils/client";
import { inAppWallet } from "thirdweb/wallets";
import { sepolia } from "thirdweb/chains";

const NavBar: React.FC = () => {
  const wallets = [
    inAppWallet({
      auth: {
        options: ["google", "email"],
      },
    }),
  ];

  // adding the states
  const [isActive, setIsActive] = useState(false);
  //add the active class
  const toggleActiveClass = () => {
    setIsActive(!isActive);
  };
  //clean up function to remove the active class
  const removeActive = () => {
    setIsActive(false);
  };
  return (
    <nav className="navbar">
      {/* logo */}
      <a href="/" className="logo-wrap">
        Spark
      </a>
      <ul className={`navMenu ${isActive ? "active" : ""}`}>
        <li onClick={removeActive}>
          <a href="/" className="navLink">
            Home
          </a>
        </li>
        <li onClick={removeActive}>
          <a href="/campaigns" className="navLink">
            Campanhas
          </a>
        </li>
        <li onClick={removeActive}>
          <a href="/athletes" className="navLink">
            Atletas
          </a>
        </li>
        <li onClick={removeActive}>
          <a href="/sobre" className="navLink">
            Sobre
          </a>
        </li>
        <li onClick={removeActive}>
          <a href="/user" className="navLink">
            Conta
          </a>
        </li>

        <li onClick={removeActive}>
          <ConnectButton
            connectButton={{
              label: "Connect",
              className: "btn-connect",
              style: {
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                justifyContent: "center",
                alignContent: "center",
                color: "#fff",
                background:
                  "linear-gradient(225deg, #ff7f08 8.12%, #f8ae0e 92.21%)",
                borderRadius: "8px",
                boxShadow: "4px 4px 28px -15px #000000d9",
                lineHeight: "1",
              },
            }}
            chain={sepolia}
            client={client}
            wallets={wallets}
            theme={"dark"}
            connectModal={{
              title: "Connect to Spark",
              welcomeScreen: { title: "Bem-vindo Spark" },
              size: "compact",
              showThirdwebBranding: false,
            }}
          />
        </li>
      </ul>
      <div
        className={`hamburger ${isActive ? "active" : ""}`}
        onClick={toggleActiveClass}
      >
        <span className="bar"></span>
        <span className="bar"></span>
        <span className="bar"></span>
      </div>
    </nav>
  );
};

export default NavBar;
