import React from 'react';
import Athlete from './Athlete';
import '../styles/FeaturedAthletes.css';
import JoaoDaSilvaProfile from '../assets/16.jpg';
import MariaSantosProfile from '../assets/91.jpg';
import PedroOliveiraProfile from '../assets/33.jpg';
import AnaProfile from '../assets/9.jpg';

const FeaturedAthletes: React.FC = () => {

  const mockAthletes = [
    {
      name: 'João Silva',
      sport: 'Atletismo',
      bio: 'Atleta olímpico com várias medalhas em campeonatos nacionais e internacionais.',
      image: JoaoDaSilvaProfile
    },
    {
      name: 'Maria Santos',
      sport: 'Natação',
      bio: 'Campeã mundial e recordista em várias categorias de natação.',
      image: MariaSantosProfile
    },
    {
      name: 'Pedro Oliveira',
      sport: 'Ginástica',
      bio: 'Ginasta renomado com múltiplas medalhas olímpicas e mundiais.',
      image: PedroOliveiraProfile
    },
    {
      name: 'Ana Rodrigues',
      sport: 'Vôlei',
      bio: 'Jogadora de vôlei profissional com diversas conquistas em torneios internacionais.',
      image: AnaProfile
    }
  ];

  return (
    <div className="athletes-featured">
      <h2 className='title'>Atletas em Destaque</h2>
      <div className="athletes-featured__list">
        {mockAthletes.map((athlete, index) => (
          <Athlete key={index} athlete={athlete} />
        ))}
      </div>
      <a className='more-athletes-button'>Mais Atletas</a>
    </div>
  );
};

export default FeaturedAthletes;
