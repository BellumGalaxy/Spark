import React, { useState } from 'react';
import "../styles/FormDoador.css";

const FormDoador: React.FC = () => {
  const [email, setEmail] = useState<string>('');
  const [isValidEmail, setIsValidEmail] = useState<boolean>(false);
  const [phone, setPhone] = useState<string>('');
  const [isValidPhone, setIsValidPhone] = useState<boolean>(false);

  const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  const phoneRegex = /^\(\d{2}\) \d{5}-\d{4}$/;

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

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (isValidEmail && isValidPhone) {
      console.log('Email válido:', email);
      console.log('Telefone válido:', phone);
    } else {
      console.log('Por favor, insira um email e telefone válidos.');
    }
  };

  return (
    <section className='backForm_Atleta'>
      
      <form onSubmit={handleSubmit} className='cardForm_Atleta>'>

        <div className='contentForm_Atleta'>
          <label>Nome</label>
          <input type="text" placeholder='Insira seu Nome' /> 

          <label>Email</label>     
          <input type="text" placeholder='Insira seu Email' value={email} onChange={handleEmailChange} />

          <label>Link do GOV.br</label>
          <input type="text" placeholder='Insira o Link' />

          <label>Telefone</label>         
          <input type="text" placeholder='Insira seu Telefone' value={phone} onChange={handlePhoneChange} />

          <label>Data de Nascimento</label>
          <input type="date" placeholder='Data de Nascimento'/>  

          <button type="submit" disabled={!isValidEmail || !isValidPhone}>Enviar</button>
          
      </div>
      </form>
    </section>
  );
};

export default FormDoador;
