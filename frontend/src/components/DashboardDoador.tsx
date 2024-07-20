import React from "react";
import SparkLogo from "../assets/logo-spark.png";
import UsdcLogo from "../assets/usdc-logo.png";
import NavBar from "./NavBar";

const DashboardDoador: React.FC = () => {
  return (
    <>
      <NavBar />
      <div className="backDashboard_Atleta">
        <div className="cardDashboardAtleta">
          <div className="titleDash">
            <h1>Olá Doador</h1>
            <p>Seja bem-vindo(a) a sua Dashboard!</p>
          </div>

          <div className="dadosAtleta">
            <div className="saldoAtleta">
              <h1>Seu Saldo</h1>
              <div className="saldoAtletaSpark">
                <img src={SparkLogo} alt="Spark Logo" />
                <p>60.800,00</p>
              </div>
            </div>
            <div className="conversao">
              <h1>Faça aqui sua Conversão</h1>
              <div className="conversaoInput">
                <div className="conversaoUsdc">
                  <label>
                    <img src={UsdcLogo} alt="USDC Logo" />
                  </label>
                  <input type="number" placeholder="Insira a quantidade" />
                </div>
                <div className="conversaoSpark">
                  <label>
                    <img src={SparkLogo} alt="Spark Logo" />
                  </label>
                  <input type="number" placeholder="Insira a quantidade" />
                </div>
              </div>
              <button>Converter</button>
            </div>
          </div>
          <div className="campanhaAtleta">
            <table>
              <thead>
                <tr>
                  <th>ID da Doação</th>
                  <th>Nome do Atleta</th>
                  <th>Valor da Doação</th>
                  <th>Status para Abatimento</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>123</td>
                  <td>Alberto José</td>
                  <td>50.000,00</td>
                  <td>Em processamento</td>
                </tr>
                <tr>
                  <td>2025</td>
                  <td>Jéssica Silva</td>
                  <td>3.000,00</td>
                  <td>Em processamento</td>
                </tr>
                <tr>
                  <td>208</td>
                  <td>Rômulo Oliveira</td>
                  <td>15.000,00</td>
                  <td>Abatimento Realizado</td>
                </tr>
                <tr>
                  <td>945</td>
                  <td>Kamila Lima</td>
                  <td>500,00</td>
                  <td>Abatimento Realizado</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </>
  );
};

export default DashboardDoador;
