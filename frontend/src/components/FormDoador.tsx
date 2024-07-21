import React, { useState } from "react";
import "../styles/FormDoador.css";
import { TransactionButton } from "thirdweb/react";
import { prepareContractCall } from "thirdweb";
import { useActiveAccount } from "thirdweb/react";
import { useNavigate } from "react-router-dom";
import { contract } from "../utils/thirdweb";

const FormDoador: React.FC = () => {
  const navigate = useNavigate();
  const activeAccount = useActiveAccount();
  const account = activeAccount?.address;

  const [isRegisteredSuccessfully, setIsRegisteredSuccessfully] =
    useState(false);
    

  const [email, setEmail] = useState<string>("");
  const [isValidEmail, setIsValidEmail] = useState<boolean>(false);
  const [phone, setPhone] = useState<string>("");
  const [isValidPhone, setIsValidPhone] = useState<boolean>(false);
  const [name, setName] = useState<string>("");
  const [linkGov, setLinkGov] = useState<string>("");
  const [birthDate, setBirthDate] = useState<string>("");

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
        type_user: "donor",
        user_validated: false,
        is_active: true,
        street_address: null,
        city: null,
        state: null,
        country: null,
        postal_code: null,
        wallet_id: account,
        // wallet_id: null,
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
        setIsRegisteredSuccessfully(true);
        // navigate("/dashboard-donor");
      } catch (error) {
        console.error("Erro ao realizar cadastro:", error);
      }
    } else {
      console.log("Por favor, insira um email e telefone válidos.");
    }
  };

  return (
    <section className="backForm_Atleta">
      <form onSubmit={handleSubmit} className="cardForm_Atleta>">
        <div className="contentForm_Atleta">
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

          <label>Data de Nascimento</label>
          <input
            type="date"
            placeholder="Data de Nascimento"
            value={birthDate}
            onChange={(e) => setBirthDate(e.target.value)}
          />

          <button type="submit" disabled={!isValidEmail || !isValidPhone}>
            Enviar
          </button>

          <TransactionButton
            disabled={!isRegisteredSuccessfully}
            transaction={() => {
              // Create a transaction object and return it
              const tx = prepareContractCall({
                contract,
                method:
                  "function benefactorRegister() external returns(bytes32 _requestId)",
                params: [],
              });
              return tx;
            }}
            onTransactionSent={(result) => {
              console.log("Transaction submitted", result.transactionHash);
            }}
            onTransactionConfirmed={(receipt) => {
              console.log("Transaction confirmed", receipt.transactionHash);
            }}
            onError={(error) => {
              console.error("Transaction error", error);
            }}
          >
            Confirm Transaction
          </TransactionButton>
        </div>
      </form>
    </section>
  );
};

export default FormDoador;
