// src/pages/Athletes.tsx
import React, { useState } from "react";
import Athlete from "../components/Athlete";
import "../styles/Athletes.css";
import NavBar from "../components/NavBar";

import JoaoDaSilvaProfile from "../assets/16.jpg";
import MariaSantosProfile from "../assets/91.jpg";
import PedroOliveiraProfile from "../assets/33.jpg";
import AnaProfile from "../assets/9.jpg";
import CarlosSouzaProfile from "../assets/carlos-souza.jpg";
import FernandaLimaProfile from "../assets/fernanda-lima.jpg";
import LucasPereiraProfile from "../assets/lucas-pereira.jpg";
import JulianaAlvesProfile from "../assets/juliana-alves.jpg";
import MateusFernandesProfile from "../assets/mateus-fernandes.jpg";
import SofiaMartinsProfile from "../assets/sofia-martins.jpg";
import RafaelCostaProfile from "../assets/rafael-costa.jpg";
import CamilaRochaProfile from "../assets/camila-rocha.jpg";
import GustavoLimaProfile from "../assets/gustavo-lima.jpg";
import BeatrizSouzaProfile from "../assets/beatriz-souza.jpg";


const Athletes: React.FC = () => {
  const [filter, setFilter] = useState("");

  const mockAthletes = [
    {
      name: "João Silva",
      sport: "Atletismo",
      bio: "Atleta olímpico com várias medalhas em campeonatos nacionais e internacionais.",
      image: JoaoDaSilvaProfile,
    },
    {
      name: "Maria Santos",
      sport: "Natação",
      bio: "Campeã mundial e recordista em várias categorias de natação.",
      image: MariaSantosProfile,
    },
    {
      name: "Pedro Oliveira",
      sport: "Ginástica",
      bio: "Ginasta renomado com múltiplas medalhas olímpicas e mundiais.",
      image: PedroOliveiraProfile,
    },
    {
      name: "Ana Rodrigues",
      sport: "Vôlei",
      bio: "Jogadora de vôlei profissional com diversas conquistas em torneios internacionais.",
      image: AnaProfile,
    },
    {
      name: "Carlos Souza",
      sport: "Futebol",
      bio: "Jogador de futebol com uma carreira internacional e diversos títulos.",
      image: CarlosSouzaProfile,
    },
    {
      name: "Fernanda Lima",
      sport: "Basquete",
      bio: "Jogadora de basquete com várias medalhas em campeonatos nacionais e internacionais.",
      image: FernandaLimaProfile,
    },
    {
      name: "Lucas Pereira",
      sport: "Boxe",
      bio: "Boxeador profissional com vários títulos mundiais.",
      image: LucasPereiraProfile,
    },
    {
      name: "Juliana Alves",
      sport: "Tênis",
      bio: "Tenista renomada com várias vitórias em torneios internacionais.",
      image: JulianaAlvesProfile,
    },
    {
      name: "Mateus Fernandes",
      sport: "Judô",
      bio: "Judoca olímpico com diversas medalhas em competições mundiais.",
      image: MateusFernandesProfile,
    },
    {
      name: "Sofia Martins",
      sport: "Ciclismo",
      bio: "Ciclista profissional com várias vitórias em competições internacionais.",
      image: SofiaMartinsProfile,
    },
    {
      name: "Rafael Costa",
      sport: "Atletismo",
      bio: "Corredor de maratonas com diversos títulos nacionais e internacionais.",
      image: RafaelCostaProfile,
    },
    {
      name: "Camila Rocha",
      sport: "Ginástica Artística",
      bio: "Ginasta artística com múltiplas medalhas em campeonatos internacionais.",
      image: CamilaRochaProfile,
    },
    {
      name: "Gustavo Lima",
      sport: "Natação",
      bio: "Nadador com várias medalhas em campeonatos nacionais e internacionais.",
      image: GustavoLimaProfile,
    },
    {
      name: "Beatriz Souza",
      sport: "Vôlei de Praia",
      bio: "Jogadora de vôlei de praia com diversas conquistas em torneios internacionais.",
      image: BeatrizSouzaProfile,
    },
  ];

  const filteredAthletes = mockAthletes.filter(
    (athlete) =>
      athlete.name.toLowerCase().includes(filter.toLowerCase()) ||
      athlete.sport.toLowerCase().includes(filter.toLowerCase())
  );

  return (
    <div>
      <NavBar />
      <div className="athletes-page">
        <h2 className="title">Nossos atletas</h2>
        <input
          type="text"
          placeholder="Filtrar por nome ou modalidade"
          value={filter}
          onChange={(e) => setFilter(e.target.value)}
          className="filter-input"
        />
        <div className="athletes-list">
          {filteredAthletes.map((athlete, index) => (
            <Athlete key={index} athlete={athlete} />
          ))}
        </div>
      </div>


    </div>
  );
};

export default Athletes;
