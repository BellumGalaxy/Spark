import React, { useState } from 'react';
import NavBar from '../components/NavBar';
import CardCampaign from '../components/CardCampaign';
import '../styles/Campaigns.css';
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

const Campaigns: React.FC = () => {
  const [filter, setFilter] = useState('');

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
    },
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

  const filteredCampaigns = mockCampaigns.filter((campaign) =>
    campaign.title.toLowerCase().includes(filter.toLowerCase()) ||
    campaign.athleteName.toLowerCase().includes(filter.toLowerCase())
  );

  return (
    <div className='campaigns-wrap'>
      <NavBar />
      <div className="campaigns">
        <h2 className='title'>Campanhas</h2>
        <input
          type="text"
          placeholder="Filtrar por nome da campanha ou atleta"
          value={filter}
          onChange={(e) => setFilter(e.target.value)}
          className="filter-input"
        />
        <div className="campaigns-list">
          {filteredCampaigns.map((campaign, index) => (
            <CardCampaign key={index} campaign={campaign} />
          ))}
        </div>
      </div>
    </div>
  )
}

export default Campaigns