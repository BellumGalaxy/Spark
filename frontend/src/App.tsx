import "./App.css";
import Athletes from "./pages/Athletes.tsx";
import Campaigns from "./pages/Campaigns.tsx";
import Homepage from "./pages/Homepage.tsx";
import RegisterConta from "./components/RegisterConta.tsx";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Sobre from "./pages/Sobre.tsx";
import DashboardAtleta from "./components/DashboardAtleta.tsx";
import DashboardPatrocinador from "./components/DashboardPatrocinador.tsx";
import DashboardDoador from "./components/DashboardDoador.tsx";

function App() {
  return (
    <>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Homepage />} />
          <Route path="/campanhas" element={<Campaigns />} />
          <Route path="/atletas" element={<Athletes />} />
          <Route path="/sobre" element={<Sobre />} />
          <Route path="/conta" element={<RegisterConta />} />
          <Route path="/dashboard-athlete" element={<DashboardAtleta />} />
          <Route path="/dashboard-donor" element={<DashboardDoador />} />
          <Route
            path="/dashboard-sponsor"
            element={<DashboardPatrocinador />}
          />
        </Routes>
      </BrowserRouter>
    </>
  );
}

export default App;
