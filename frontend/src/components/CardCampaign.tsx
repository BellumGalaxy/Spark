import React from 'react';
import '../styles/CardCampaign.css';

interface Campaign {
  title: string;
  athleteName: string;
  description: string;
  goal: number;
  image: string;
}

interface CardCampaignProps {
  campaign: Campaign;
}

const CardCampaign: React.FC<CardCampaignProps> = ({ campaign }) => {
  return (
    <div className="campaign-card">
      <img src={campaign.image} alt={campaign.title} className="campaign-card__image" />
      <div className="campaign-card__content">
        <h2 className="campaign-card__title">{campaign.title}</h2>
        <p className="campaign-card__athlete">{campaign.athleteName}</p>
        <p className="campaign-card__description">{campaign.description}</p>
        <p className="campaign-card__goal">Objetivo: R${campaign.goal}</p>
        <div className='buttons-wrap'>
            <button className="campaign-card__donate-button">Apoiar</button>
            <button className="campaign-card__details-button">Detalhes</button>
        </div>
      </div>
    </div>
  );
};

export default CardCampaign;
