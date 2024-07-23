import React, { useEffect, useState } from "react";
import "../styles/DashboardAtleta.css";
import SparkLogo from "../assets/logo-spark.png";
import UsdcLogo from "../assets/usdc-logo.png";
import NavBar from "./NavBar";
import axios from "axios";
import { client, contract } from "../utils/thirdweb";
import { useActiveAccount } from "thirdweb/react";
import { useWalletBalance } from "thirdweb/react";

const DashboardAtleta: React.FC = () => {
  const [athleteApiData, setAthleteApiData] = useState(null);
  const [firstName, setFirstName] = useState("");
  const [isLoading, setIsLoading] = useState<boolean>(true);

  const activeAccount = useActiveAccount();

  console.log("wallet id:", activeAccount?.address);

  useEffect(() => {
    const fetchAthleteApiData = async () => {
      if (activeAccount?.address) {
        try {
          const response = await axios.get(
            `http://142.93.189.23:8000/api/users/user/${activeAccount.address}/`
          );
          setAthleteApiData(response.data);
          setFirstName(response.data.first_name);
          setIsLoading(false);
        } catch (error) {
          console.error("Erro ao buscar dados da API:", error);
          setIsLoading(false);
        }
      }
    };

    fetchAthleteApiData();
  }, [activeAccount?.address]);

  const { data: tokenBalance, isLoading: isBalanceLoading } = useWalletBalance({
    address: activeAccount?.address,
    chain: contract.chain,
    client: client,
    tokenAddress: "0xEdC257E2cB2E1433b3865DdDAFEDAE551d9be389",
  });

  return (
    <>
      <NavBar />
      <div className="backDashboardAtleta">
        <div className="cardDashboardAtleta">
          <div className="titleDash">
            {isLoading ? <h1>Carregando...</h1> : <h1>Olá, {firstName}</h1>}
            <p>Seja bem-vindo(a) a sua Dashboard!</p>
          </div>

          <div className="dadosAtleta">
            <div className="line-content">
              <div className="saldoAtleta">
                <h1>Seu Saldo</h1>
                <div className="saldoAtletaSpark">
                  <img src={SparkLogo} alt="Spark Logo" />
                  <p>
                    {isBalanceLoading
                      ? "Carregando saldo..."
                      : tokenBalance?.displayValue}
                  </p>
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

              <div className="criarCampanha">
                <h1>Crie uma Campanha</h1>
                <input type="text" placeholder="Nome da Campanha" />
                <input type="number" placeholder="Meta de Arrecadação" />
                <label>Duração da Campanha</label>
                <input type="date" placeholder="Duração da campanha" />
                <button>Criar Campanha</button>
              </div>
            </div>

            <table>
              <thead>
                <tr>
                  <th>ID da Campanha</th>
                  <th>Nome da Campanha</th>
                  <th>Data de Início</th>
                  <th>Data de Término</th>
                  <th>Meta de Arrecadação</th>
                  <th>Valor Arrecadado</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>123</td>
                  <td>Olímpiadas Paris</td>
                  <td>20/06/2024</td>
                  <td>26/07/2024</td>
                  <td>150.000,00</td>
                  <td>47.500,00</td>
                </tr>
                <tr>
                  <td>2025</td>
                  <td>Triatlo Florianópolis</td>
                  <td>25/02/2024</td>
                  <td>30/02/2024</td>
                  <td>20.000,00</td>
                  <td>2.300,00</td>
                </tr>
                <tr>
                  <td>208</td>
                  <td>Maratona São Silvestre</td>
                  <td>01/12/2024</td>
                  <td>15/12/2024</td>
                  <td>15.000,00</td>
                  <td>14.900,00</td>
                </tr>
                <tr>
                  <td>945</td>
                  <td>Veneza Run</td>
                  <td>01/01/2025</td>
                  <td>10/01/2025</td>
                  <td>40.000,00</td>
                  <td>22.000,00</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </>
  );
};

export default DashboardAtleta;
