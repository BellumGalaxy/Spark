import React, { useState } from 'react';
import "../styles/FormPatrocinador.css";

const FormPatrocinador: React.FC = () => {
  const [email, setEmail] = useState<string>('');
  const [isValidEmail, setIsValidEmail] = useState<boolean>(false);
  const [phone, setPhone] = useState<string>('');
  const [isValidPhone, setIsValidPhone] = useState<boolean>(false);
  const [cnpj, setCnpj] = useState<string>('');
  const [isValidCnpj, setIsValidCnpj] = useState<boolean>(false);

  const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  const phoneRegex = /^\(\d{2}\) \d{5}-\d{4}$/;
  const cnpjRegex = /^\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}$/;

  const handleEmailChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const newEmail = event.target.value;
    const isValid = emailRegex.test(newEmail);
    setEmail(newEmail);
    setIsValidEmail(isValid);
  };

  const handlePhoneChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    let newPhone = event.target.value.replace(/\D/g, '');

    if (newPhone.length > 11) {
      newPhone = newPhone.slice(0, 11);
    }

    const formattedPhone = newPhone.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
    setPhone(formattedPhone);

    const isValid = phoneRegex.test(formattedPhone);
    setIsValidPhone(isValid);
  };

  const handleCnpjChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    let newCnpj = event.target.value.replace(/\D/g, '');

    if (newCnpj.length > 14) {
      newCnpj = newCnpj.slice(0, 14);
    }

    const formattedCnpj = newCnpj.replace(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, '$1.$2.$3/$4-$5');
    setCnpj(formattedCnpj);

    const isValid = cnpjRegex.test(formattedCnpj);
    setIsValidCnpj(isValid);
  };

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (isValidEmail && isValidPhone && isValidCnpj) {
      console.log('Email válido:', email);
      console.log('Telefone válido:', phone);
      console.log('CNPJ válido:', cnpj);
    } else {
      console.log('Por favor, insira um email, telefone e CNPJ válidos.');
    }
  };

  return (
    <section className='backForm_Atleta'>
      <form onSubmit={handleSubmit} className='cardForm_Atleta>'>
        <div className='contentForm_Atleta'>
          <label>Razão Social</label>
          <input type="text" placeholder='Insira a Razão Social da Empresa' />
          <label>CNPJ</label>
          <input type="text" placeholder='Insira o CNPJ da Empresa' value={cnpj} onChange={handleCnpjChange}/>       
          <label>Email</label>     
          <input type="text" placeholder='Insira seu Email' value={email} onChange={handleEmailChange} />
          <label>Insira o Link do GOV.br</label>
          <input type="text" placeholder='Insira o Link' />
          <label>Telefone</label>         
          <input type="text" placeholder='Insira seu Telefone' value={phone} onChange={handlePhoneChange} />    
          <button type="submit" disabled={!isValidEmail || !isValidPhone || !isValidCnpj}>Enviar</button>
      </div>
      </form>
    </section>
  );
};

export default FormPatrocinador;
