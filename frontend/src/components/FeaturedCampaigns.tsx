import React from 'react';
import CardCampaign from './CardCampaign';
import '../styles/FeaturedCampaigns.css';
import Projeto1 from '../assets/medalha-de-ouro-atletismo.png';
import Projeto2 from '../assets/rumo-as-olimpiadas-2024.png';
import Projeto3 from '../assets/apoio-ao-ginasta.png';
import Projeto4 from '../assets/sonho-olimpico.png';

interface Campaign {
  title: string;
  athleteName: string;
  description: string;
  goal: number;
  image: string;
}

const FeaturedCampaigns: React.FC = () => {

  const mockCampaigns: Campaign[] = [
    {
      title: 'Projeto Medalha de Ouro',
      athleteName: 'João Silva',
      description: 'Estou buscando apoio para cobrir os custos de treinamento, equipamentos e viagens necessárias para minha participação nas Olimpíadas de 2024.',
      goal: 50000,
      image: Projeto1
    },
    {
      title: 'Rumo às Olimpíadas 2024',
      athleteName: 'Maria Santos',
      description: 'Ajude-me a alcançar meu sonho olímpico de conquistar a medalha de ouro na natação.',
      goal: 30000,
      image: Projeto2
    },
    {
      title: 'Campanha de Apoio ao Ginasta',
      athleteName: 'Pedro Oliveira',
      description: 'Contribua para minha jornada esportiva e ajude-me a representar nosso país nas competições internacionais de ginástica.',
      goal: 25000,
      image: Projeto3
    },
    {
      title: 'Sonho Olímpico',
      athleteName: 'Ana Rodrigues',
      description: 'Estou treinando arduamente para as Olimpíadas de 2024. Sua contribuição faz a diferença!',
      goal: 40000,
      image: Projeto4
    }
  ];

  return (
    <div className="featured-campaigns">
      <h2 className='title'>Campanhas em Destaque</h2>
      <div className="campaigns-list">
        {mockCampaigns.map((campaign, index) => (
          <CardCampaign key={index} campaign={campaign} />
        ))}
      </div>
      <a href='/campaigns' className='more-campaigns-button'>Mais campanhas</a>
    </div>
  );
};

export default FeaturedCampaigns;
