import React, { useRef } from 'react';
import '../styles/BigNumbers.css';
import CountUp from 'react-countup';
import useIntersectionObserver from '../hooks/useIntersectionObserver';

const BigNumbers: React.FC = () => {
  const ref = useRef<HTMLDivElement>(null);
  const isVisible = useIntersectionObserver(ref);

  return (
    <div className='bignumbers-wrap' ref={ref}>
      <h2>Nosso Impacto em Números</h2>
      <p className='subtitle'>Resultados alcançados com o apoio de nossos patrocinadores e comunidade</p>
      <div className='bignumbers-content-wrap'>
        <div className='bignumber-individual-wrap'>
          {isVisible && <CountUp className='number' start={0} end={753} duration={20} />}
          <p className='description'>Campanhas apoiadas</p>
        </div>
        <div className='bignumber-individual-wrap'>
          {isVisible && <CountUp className='number' start={0} end={456} duration={20} />}
          <p className='description'>Atletas patrocinados</p>
        </div>
        <div className='bignumber-individual-wrap'>
          {isVisible && <CountUp className='number' start={0} end={1346218.02} duration={20} prefix="R$ " separator="." decimal="," decimals={2} />}
          <p className='description'>Valor arrecadado</p>
        </div>
      </div>
    </div>
  )
}

export default BigNumbers