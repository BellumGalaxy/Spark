// src/pages/Sobre.tsx
import React from 'react';
import NavBar from '../components/NavBar';
import '../styles/Sobre.css';
import Bellum from '../components/Bellum';

const Sobre: React.FC = () => {
  return (
    <div>
      <NavBar />
      <div className="sobre-page">
        <h1 className="title">Sobre o Projeto</h1>
        <div className="content">
          <section>
            <h2>Visão</h2>
            <p>
              Nosso projeto visa conectar atletas talentosos com patrocinadores
              que possam ajudá-los a alcançar seus objetivos e sonhos no esporte.
              Acreditamos no poder do esporte para transformar vidas e queremos
              ser parte dessa jornada.
            </p>
          </section>
          <section>
            <h2>Missão</h2>
            <p>
              Nossa missão é fornecer uma plataforma acessível e eficaz para
              que atletas possam divulgar suas campanhas de financiamento e
              alcançar o apoio necessário. Facilitamos o processo de doações
              para os patrocinadores, garantindo que suas contribuições sejam
              usadas de maneira transparente e eficiente.
            </p>
          </section>
          <section>
            <h2>Valores</h2>
            <p>
              Transparência, integridade e compromisso com o desenvolvimento
              esportivo são os pilares que sustentam nosso projeto. Valorizamos
              a dedicação dos atletas e a generosidade dos patrocinadores,
              trabalhando incansavelmente para criar um ambiente de confiança e
              respeito mútuo.
            </p>
          </section>
          <section>
            <h2>Como Funciona</h2>
            <p>
              Atletas podem se cadastrar na nossa plataforma e criar campanhas
              detalhadas, especificando suas necessidades e objetivos. Os
              patrocinadores, por sua vez, podem navegar pelas campanhas,
              escolher os atletas que desejam apoiar e fazer suas doações de
              forma segura e rápida.
            </p>
          </section>
        </div>
      </div>
      <Bellum />
    </div>
  );
};

export default Sobre;
