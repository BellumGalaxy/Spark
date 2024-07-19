import "./App.css";
import Athletes from "./pages/Athletes";
import Campaigns from "./pages/Campaigns";
import Homepage from "./pages/Homepage";
import RegisterConta from "./components/RegisterConta";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Sobre from "./pages/Sobre";

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
        </Routes>
      </BrowserRouter>
    </>
  );
}

export default App;
