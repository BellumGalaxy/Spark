import { useState } from "react";
import React from "react";
import "../styles/RegisterConta.css";
import FormAtleta from "./FormAtleta";
import FormPatrocinador from "./FormPatrocinador";
import FormDoardor from "./FormDoador";
import NavBar from "./NavBar";

const RegisterConta: React.FC = () => {
  const [activeTab, setActiveTab] = useState("");

  const handleTabClick = (tab: string) => {
    setActiveTab(tab);
  };

  return (
    <div>
      <NavBar />

      <div className="backRegister">
        <div className="contentRegister">
          <div className="titleTop_register">
            <h1>Crie sua Conta </h1>
            <p>Bem vindo! Insira suas informações abaixo.</p>

            <div className="tabs">
              <button
                type="button"
                onClick={() => handleTabClick("tabAtle")}
                className={`tab ${activeTab === "tabAtle" ? "active" : ""}`}
              >
                Sou um Atleta
              </button>
              <button
                type="button"
                onClick={() => handleTabClick("tabPatro")}
                className={`tab ${activeTab === "tabPatro" ? "active" : ""}`}
              >
                Sou um Patrocinador
              </button>
              <button
                type="button"
                onClick={() => handleTabClick("tabDoa")}
                className={`tab ${activeTab === "tabDoa" ? "active" : ""}`}
              >
                Sou um Doador
              </button>
            </div>
          </div>

          <div className="contentTabs">
            {activeTab === "tabAtle" && (
              <div>
                <FormAtleta />
              </div>
            )}
            {activeTab === "tabPatro" && (
              <div>
                <FormPatrocinador />
              </div>
            )}
            {activeTab === "tabDoa" && (
              <div>
                <FormDoardor />
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default RegisterConta;
