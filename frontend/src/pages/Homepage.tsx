import React, { useEffect } from 'react';
import AOS from 'aos';
import 'aos/dist/aos.css';
import '../styles/Homepage.css';
import NavBar from '../components/NavBar';
import Hero from '../components/Hero';
import BigNumbers from '../components/BigNumbers';
import FeaturedCampaigns from '../components/FeaturedCampaigns';
import HowItWorks from '../components/HowItWorks';
import FeaturedAthletes from '../components/FeaturedAthletes';
import Partners from '../components/Partners';
import Bellum from '../components/Bellum';
import Footer from '../components/Footer';

const Homepage: React.FC = () => {
  useEffect(() => {
    AOS.init({
      duration: 1200,
    });
  }, []);
  
  return (
    <div>
        <Hero />
        <BigNumbers />
        <FeaturedCampaigns />
        <HowItWorks />
        <FeaturedAthletes />
        <Partners />
        <Bellum />
        <Footer />
    </div>
  )
}

export default Homepage