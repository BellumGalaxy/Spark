import React from 'react';
import '../styles/Athlete.css';

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
        <div className='athlete-card__name-profile-wrap'>
            <img src={athlete.image} alt={athlete.name} className="athlete-card__image" />
            <h2 className="athlete-card__name">{athlete.name}</h2>
        </div>
        
        <p className="athlete-card__sport">{athlete.sport}</p>
        <p className="athlete-card__bio">{athlete.bio}</p>

        <button className="athlete-card__details-button">Detalhes</button>
      </div>
    </div>
  );
};

export default Athlete;
