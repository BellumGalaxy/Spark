import React from 'react';
import '../styles/HowItWorks.css';
import MedalIcon from '../assets/medal-solid.svg';
import CheckIcon from '../assets/check-solid.svg';
import ShieldIcon from '../assets/shield-icon.svg';
import HandMoneyIcon from '../assets/hand-holding-dollar-solid.svg';
import TargetIcon from '../assets/bullseye-solid.svg';
import PigBankIcon from '../assets/piggy-bank-solid.svg';

const HowItWorks: React.FC = () => {
  return (
    <div className="how-it-works-wrap">
        <img src={MedalIcon} />
      <h2>Como Funciona</h2>
      <p><img src={PigBankIcon} />Atletas podem criar campanhas para arrecadar fundos e alcançar seus sonhos.</p>
      <p><img src={TargetIcon} />Atletas compartilham suas histórias e metas esportivas. </p>
      <p><img src={HandMoneyIcon} />Apoiadores podem explorar essas campanhas e escolher como ajudar.</p>
      <p><img src={ShieldIcon} />Nossa tecnologia garante que todas as transações sejam seguras e transparentes.</p>
      <div className='cta-wrap'>
        <p>Junte-se a nós e faça a diferença!</p>
        <button>Comece agora</button>
      </div>
    </div>
  );
};

export default HowItWorks;