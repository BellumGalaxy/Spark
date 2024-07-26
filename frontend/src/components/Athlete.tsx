import React from "react";
import "../styles/Athlete.css";

interface Athlete {
  name: string;
  sport: string;
  bio: string;
  image: string;
}

interface AthleteProps {
  athlete: Athlete;
}

const Athlete: React.FC<AthleteProps> = ({ athlete }) => {
  return (
    <div className="athlete-card">
      <div className="athlete-card__content">
        <div className="athlete-card__name-profile-wrap">
          <img
            src={athlete.image}
            alt={athlete.name}
            className="athlete-card__image"
          />
          <h2 className="athlete-card__name">{athlete.name}</h2>
        </div>

        <div className="athlete-card__sport-and-follow-user-wrap">
          <p className="athlete-card__sport">{athlete.sport}</p>
          <svg
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            width="30"
            height="30"
            fill="none"
            viewBox="0 0 24 24"
          >
            <path
              stroke="currentColor"
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth="2"
              d="M16 12h4m-2 2v-4M4 18v-1a3 3 0 0 1 3-3h4a3 3 0 0 1 3 3v1a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1Zm8-10a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z"
            />
          </svg>
        </div>

        <p className="athlete-card__bio">{athlete.bio}</p>

        <button className="athlete-card__details-button">Detalhes</button>
      </div>
    </div>
  );
};

export default Athlete;
