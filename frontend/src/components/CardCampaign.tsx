import React from "react";
import "../styles/CardCampaign.css";

interface Campaign {
  title: string;
  athleteName: string;
  description: string;
  goal: number;
  collected: number;
  image: string;
}

interface CardCampaignProps {
  campaign: Campaign;
}

const formatCurrency = (value: number): string => {
  return new Intl.NumberFormat("pt-BR", {
    style: "currency",
    currency: "BRL",
  }).format(value);
};

const CardCampaign: React.FC<CardCampaignProps> = ({ campaign }) => {
  const percentageCollected = Math.min(
    (campaign.collected / campaign.goal) * 100,
    100
  );

  return (
    <div className="campaign-card">
      <img
        src={campaign.image}
        alt={campaign.title}
        className="campaign-card__image"
      />
      <div className="campaign-card__content">
        <h2 className="campaign-card__title">{campaign.title}</h2>
        <div className="campaign-card__athlete-fav-wrap">
          <p className="campaign-card__athlete">{campaign.athleteName}</p>
          <svg
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            fill="none"
            viewBox="0 0 24 24"
          >
            <path
              stroke="currentColor"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              d="M12.01 6.001C6.5 1 1 8 5.782 13.001L12.011 20l6.23-7C23 8 17.5 1 12.01 6.002Z"
            />
          </svg>
        </div>

        <div className="campaign-card__time-left">
          <svg
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            width="24"
            height="24"
            fill="none"
            viewBox="0 0 24 24"
          >
            <path
              stroke="currentColor"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              d="M12 8v4l3 3m6-3a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"
            />
          </svg>
          <p>25 dias para acabar</p>
        </div>
        <p className="campaign-card__description">{campaign.description}</p>
        <div className="campaign-card__progress-bar-wrap">
          <div
            className="campaign-card__progress-bar"
            style={{ width: `${percentageCollected}%` }}
          ></div>
        </div>
        <div className="campaign-card__values">
          <p className="campaign-card__goal">
            Arrecadado: {formatCurrency(campaign.collected)}
          </p>
          <p className="campaign-card__goal">
            Meta: {formatCurrency(campaign.goal)}
          </p>
        </div>

        <div className="buttons-wrap">
          {/*<button className="campaign-card__donate-button">Apoiar</button>*/}
          <button className="campaign-card__details-button">Detalhes</button>
        </div>
      </div>
    </div>
  );
};

export default CardCampaign;
