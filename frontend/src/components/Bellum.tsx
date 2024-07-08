import '../styles/Bellum.css';
import BellumLogo from '../assets/logo-bellum.svg';
import discordLogo from '../assets/discord-icon.svg';
import githubLogo from '../assets/github-icon.svg';
import instagramLogo from '../assets/instagram-icon.svg';
import linkedinLogo from '../assets/linkedin-icon.svg';
import xLogo from '../assets/x-twitter-icon.svg';

function Bellum() {
  return (
    <div id='bellum' className='bellum-wrap'>
        <img className='bellum-logo' src={BellumLogo} alt='Bellum Logo' />
        <h4>Bellum Galaxy</h4>
        <p>We are an educational, scientific and technological community, focused on breaking barriers and demystifying technology.
        <br /><br />
        Our mission is to empower individuals by providing learning and development opportunities, where contributions fuel innovation and drive positive change.</p>
        <div className='links-wrap'>
            <a target="_blank" rel="noreferrer" href='https://discord.com/invite/H2UpdzbbRJ'><img src={discordLogo} alt='discord logo' />Discord</a>
            <a target="_blank" rel="noreferrer" href='https://github.com/BellumGalaxy/'><img src={githubLogo} alt='github logo' />Github</a>
            <a target="_blank" rel="noreferrer" href='https://www.instagram.com/bellumgalaxy/'><img src={instagramLogo} alt='instagram logo' />Instagram</a>
            <a target="_blank" rel="noreferrer" href='https://www.linkedin.com/company/bellum-galaxy/'><img src={linkedinLogo} alt='linkedin logo' />Linkedin</a>
            <a target="_blank" rel="noreferrer" href='https://x.com/bellumgalaxy'><img src={xLogo} alt='x logo' />X</a>
        </div>
    </div>
  )
}

export default Bellum