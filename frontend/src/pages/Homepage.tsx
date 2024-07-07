import React from 'react';
import '../styles/Homepage.css';
import NavBar from '../components/NavBar';
import Hero from '../components/Hero';
import BigNumbers from '../components/BigNumbers';
import FeaturedCampaigns from '../components/FeaturedCampaigns';

const Homepage = () => {
  return (
    <div>
        <NavBar />
        <Hero />
        <BigNumbers />
        <FeaturedCampaigns />
    </div>
  )
}

export default Homepage