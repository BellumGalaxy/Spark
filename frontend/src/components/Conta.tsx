import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles/Conta.css";
import NavBar from "./NavBar";

const Conta: React.FC = () => {
  const navigate = useNavigate();

  const handleRegisterClick = () => {
    navigate("/registerConta");
  };

  return (
    <>
      <NavBar />
      <form>
        <div className="bg_conta">
          <div className="card_conta">
            <div className="titleConta">
              <h1>Spark</h1>
            </div>
            <input
              type="text"
              placeholder="Insira aqui o Email"
              className="textInput_conta"
            />
            <input
              type="password"
              placeholder="Insira aqui a Senha"
              className="passwordInput_conta"
            />
            <button type="button" className="buttonConta">
              Entrar
            </button>
            <div className="rememberConta">
              <a>Esqueceu a senha?</a>
            </div>
            <div className="marginButton">
              <button
                type="button"
                className="buttonRegister"
                onClick={handleRegisterClick}
              >
                Cadastre-se
              </button>
            </div>
          </div>
        </div>
      </form>
    </>
  );
};

export default Conta;
