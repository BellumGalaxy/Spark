import React, { useState } from "react";
import "../styles/FormAtleta.css";
import { useSendTransaction } from "thirdweb/react";
import { useNavigate } from "react-router-dom";
import { contract } from "../utils/thirdweb"; // Certifique-se de que este caminho esteja correto
import { prepareContractCall } from "thirdweb";

const FormAtleta: React.FC = () => {
  const navigate = useNavigate();
  const { mutate: sendTransaction } = useSendTransaction();

  const [email, setEmail] = useState<string>("");
  const [isValidEmail, setIsValidEmail] = useState<boolean>(false);
  const [phone, setPhone] = useState<string>("");
  const [isValidPhone, setIsValidPhone] = useState<boolean>(false);
  const [name, setName] = useState<string>("");
  const [linkGov, setLinkGov] = useState<string>("");
  const [birthDate, setBirthDate] = useState<string>("");
  const [sport, setSport] = useState<string>("");
  const [category, setCategory] = useState<string>("");

  const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
  const phoneRegex = /^\(\d{2}\) \d{5}-\d{4}$/;

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

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (isValidEmail && isValidPhone) {
      const user = {
        email,
        password: "defaultPassword123",
        username: email,
        first_name: name,
        bio: null,
        location: null,
        birth_date: birthDate,
        type_user: "athlete",
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

        // call smart contract
        const transaction = prepareContractCall({
          contract,
          method:
            "function athleteRegister() returns (uint256 _athleteId, bytes32 _requestId)",
          params: [],
        });

        await sendTransaction(transaction);

        console.log("Transaction: ", transaction);
        console.log("Cadastro realizado com sucesso:", data);
        navigate("/dashboard-athlete");
      } catch (error) {
        console.error("Erro ao realizar cadastro:", error);
      }
    } else {
      console.log("Por favor, insira um email e telefone válidos.");
    }
  };

  return (
    <section className="backForm_Atleta">
      <div className="cardForm_Atleta">
        <form onSubmit={handleSubmit} className="contentForm_Atleta">
          <label>Nome</label>
          <input
            type="text"
            placeholder="Insira seu Nome"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />

          <label>Email</label>
          <input
            type="text"
            placeholder="Insira seu Email"
            value={email}
            onChange={handleEmailChange}
          />

          {/* <label>Link Gov.br</label>
          <input
            type="text"
            placeholder="Insira o link gov.br"
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

          <label>Data de Nascimento</label>
          <input
            type="date"
            placeholder="Data de Nascimento"
            value={birthDate}
            onChange={(e) => setBirthDate(e.target.value)}
          />

          <label>Esporte</label>
          <input
            type="text"
            placeholder="Esporte"
            value={sport}
            onChange={(e) => setSport(e.target.value)}
          />

          <label>Categoria</label>
          <input
            type="text"
            placeholder="Opcional"
            value={category}
            onChange={(e) => setCategory(e.target.value)}
          />

          <button type="submit" disabled={!isValidEmail || !isValidPhone}>
            Enviar
          </button>
        </form>
      </div>
    </section>
  );
};

export default FormAtleta;
