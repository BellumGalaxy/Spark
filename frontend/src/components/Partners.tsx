import React from 'react';
import '../styles/Partners.css';
import ChainlinkLogo from '../assets/Chainlink-Logo-Blue.svg';
import LaChainLogo from '../assets/la-chain-logo.png';
import BlockchainRio from '../assets/blockchain-rio-logo.png';

const Partners: React.FC = () => {
  return (
   <div className="partners">
      <h2 className="title" data-aos="fade-down">Parceiros</h2>
      <div className="partners__list">
        <div className="partner-card" data-aos="zoom-in" data-aos-delay="200">
          <img src={ChainlinkLogo} alt="Patrocinador 1" className="partner-card__logo" />
        </div>
        <div className="partner-card" data-aos="zoom-in" data-aos-delay="400">
          <img src={LaChainLogo} alt="Patrocinador 2" className="partner-card__logo" />
        </div>
        <div className="partner-card" data-aos="zoom-in" data-aos-delay="600">
          <img src={BlockchainRio} alt="Patrocinador 3" className="partner-card__logo" />
        </div>
      </div>
    </div>
  );
};

export default Partners;
