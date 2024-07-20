import "./App.css";
import Athletes from "./pages/Athletes";
import Campaigns from "./pages/Campaigns";
import Homepage from "./pages/Homepage";
import RegisterConta from "./components/RegisterConta";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Sobre from "./pages/Sobre";
import DashboardAtleta from "./components/DashboardAtleta";
import DashboardPatrocinador from "./components/DashboardPatrocinador";
import DashboardDoador from "./components/DashboardDoador";

function App() {
  return (
    <>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Homepage />} />
          <Route path="/campaigns" element={<Campaigns />} />
          <Route path="/athletes" element={<Athletes />} />
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
