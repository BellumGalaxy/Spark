import React from "react";
import "../styles/Hero.css";
import SparkLogo from "../assets/logo-spark.png";

const Hero: React.FC = () => {
  return (
    <section className="hero-wrap">
      <div className="hero-content-wrap">
        <img src={SparkLogo} />
        <h1>Transforme Sonhos em Realidade</h1>
        <p>O futuro do esporte impulsionado com o apoio da comunidade</p>
        <button>Comece Agora</button>
      </div>
    </section>
  );
};

export default Hero;
