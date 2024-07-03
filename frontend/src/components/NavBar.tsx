import { useState } from "react";
import "../layouts/NavBar.css";


const NavBar: React.FC = () => {
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
          <a href="https://" className="navLink">
            <button className="btn-connect">Conecte</button>
          </a>
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
