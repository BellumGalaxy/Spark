import React, { useState } from "react";
import "../styles/FormPatrocinador.css";
import { useActiveAccount } from "thirdweb/react";
import { useNavigate } from "react-router-dom";

const FormPatrocinador: React.FC = () => {
  const activeAccount = useActiveAccount();
  const navigate = useNavigate();

  const [email, setEmail] = useState<string>("");
  const [isValidEmail, setIsValidEmail] = useState<boolean>(false);
  const [phone, setPhone] = useState<string>("");
  const [isValidPhone, setIsValidPhone] = useState<boolean>(false);
  const [cnpj, setCnpj] = useState<string>("");
  const [isValidCnpj, setIsValidCnpj] = useState<boolean>(false);
  const [companyName, setCompanyName] = useState<string>("");
  const [linkGov, setLinkGov] = useState<string>("");

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
    let newPhone = event.target.value.replace(/\D/g, "");

    if (newPhone.length > 11) {
      newPhone = newPhone.slice(0, 11);
    }

    const formattedPhone = newPhone.replace(
      /(\d{2})(\d{5})(\d{4})/,
      "($1) $2-$3"
    );
    setPhone(formattedPhone);

    const isValid = phoneRegex.test(formattedPhone);
    setIsValidPhone(isValid);
  };

  const handleCnpjChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    let newCnpj = event.target.value.replace(/\D/g, "");

    if (newCnpj.length > 14) {
      newCnpj = newCnpj.slice(0, 14);
    }

    const formattedCnpj = newCnpj.replace(
      /(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/,
      "$1.$2.$3/$4-$5"
    );
    setCnpj(formattedCnpj);

    const isValid = cnpjRegex.test(formattedCnpj);
    setIsValidCnpj(isValid);
  };

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (isValidEmail && isValidPhone && isValidCnpj) {
      const user = {
        email,
        password: "defaultPassword123",
        username: email,
        first_name: companyName,
        bio: null,
        location: null,
        birth_date: null,
        type_user: "sponsor",
        user_validated: false,
        is_active: true,
        street_address: null,
        city: null,
        state: null,
        country: null,
        postal_code: null,
        //wallet_id: activeAccount?.address,
        wallet_id: null,
        link_gov: linkGov,
      };

      try {
        const response = await fetch("http://142.93.189.23:8000/api/users/", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(user),
        });

        if (!response.ok) {
          const errorDetails = await response.json();
          throw new Error(
            `Erro na requisição: ${response.status} - ${
              response.statusText
            } - ${JSON.stringify(errorDetails)}`
          );
        }

        const data = await response.json();
        console.log("Cadastro realizado com sucesso:", data);

        // Enviar link gov para validação
        // const validateResponse = await fetch("http://142.93.189.23:8000/api/users/validate-signature/", {
        //   method: "POST",
        //   headers: {
        //     "Content-Type": "application/json",
        //   },
        //   body: JSON.stringify({ link_gov: linkGov }),
        // });

        // if (!validateResponse.ok) {
        //   const errorDetails = await validateResponse.json();
        //   throw new Error(
        //     `Erro na validação: ${validateResponse.status} - ${
        //       validateResponse.statusText
        //     } - ${JSON.stringify(errorDetails)}`
        //   );
        // }

        // const validateData = await validateResponse.json();
        // console.log("Validação realizada com sucesso:", validateData);

        navigate("/dashboard-sponsor");
      } catch (error) {
        console.error("Erro ao realizar cadastro:", error);
      }
    } else {
      console.log("Por favor, insira um email, telefone e CNPJ válidos.");
    }
  };

  return (
    <section className="backForm_Atleta">
      <form onSubmit={handleSubmit} className="cardForm_Atleta">
        <div className="contentForm_Atleta">
          <label>Razão Social</label>
          <input
            type="text"
            placeholder="Insira a Razão Social da Empresa"
            value={companyName}
            onChange={(e) => setCompanyName(e.target.value)}
          />

          <label>CNPJ</label>
          <input
            type="text"
            placeholder="Insira o CNPJ da Empresa"
            value={cnpj}
            onChange={handleCnpjChange}
          />

          <label>Email</label>
          <input
            type="text"
            placeholder="Insira seu Email"
            value={email}
            onChange={handleEmailChange}
          />

          {/* <label>Insira o Link do GOV.br</label>
          <input
            type="text"
            placeholder="Insira o Link"
            value={linkGov}
            onChange={(e) => setLinkGov(e.target.value)}
          /> */}

          <label>Telefone</label>
          <input
            type="text"
            placeholder="Insira seu Telefone"
            value={phone}
            onChange={handlePhoneChange}
          />

          <button
            type="submit"
            disabled={!isValidEmail || !isValidPhone || !isValidCnpj}
          >
            Enviar
          </button>
        </div>
      </form>
    </section>
  );
};

export default FormPatrocinador;
