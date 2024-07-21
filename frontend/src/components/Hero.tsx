import React from "react";
import "../styles/Hero.css";

const Hero: React.FC = () => {
  return (
    <section className="hero-wrap">
      <div className="hero-content-wrap">
        <h2 className="spark-title">Spark</h2>
        <h1>Transforme Sonhos em Realidade</h1>
        <p>O futuro do esporte impulsionado com o apoio da comunidade</p>
        <button>Comece Agora</button>
      </div>
    </section>
  );
};

export default Hero;
