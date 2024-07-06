import { useState } from "react";
import "../layouts/NavBar.css";
import SparkLogo from '../assets/logo-spark.png';
import { ConnectButton } from "thirdweb/react";
import { client } from "../utils/client";
import { inAppWallet } from "thirdweb/wallets";

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
      <a href="https://" className="logo-wrap">
        <img src={SparkLogo} className="logo" />
      </a>
      <ul className={`navMenu ${isActive ? "active" : ""}`}>
        
        <li onClick={removeActive}>
          <a href="https://" className="navLink">
            Campanhas
          </a>
        </li>
        <li onClick={removeActive}>
          <a href="https://" className="navLink">
            Sobre
          </a>
        </li>
        <li onClick={removeActive}>
          <a href="https://" className="navLink">
            Conta
          </a>
        </li>
        
        <li onClick={removeActive}>
            <ConnectButton
                connectButton={{
                    label: "Connect",
                    className: "btn-connect",
                    style: {
                        alignContent: "center",
                        padding: ".6em",
                        color:"#fff",
                        background: "linear-gradient(225deg, #ff7f08 8.12%, #f8ae0e 92.21%)",
                        borderRadius: "10px",
                    },
                }} 
                client={client}
                wallets={wallets}
                theme={"dark"}
                connectModal={{
                    title: "Connect to Spark",
                    welcomeScreen: { title: "Bem-vindo Spark" },
                    size: "compact",
                    showThirdwebBranding: false
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
}

export default NavBar;