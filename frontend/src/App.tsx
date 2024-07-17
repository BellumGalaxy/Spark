import './App.css';
import Athletes from './pages/Athletes';
import Campaigns from './pages/Campaigns';
import Homepage from './pages/Homepage';
import Conta from './components/Conta';
import RegisterConta from './components/RegisterConta';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Sobre from './pages/Sobre';


function App() {

  return (
    <>
     <BrowserRouter>
        <Routes>
          <Route path="/" element={<RegisterConta />} />
          <Route path="/conta" element={<Conta />} />
            <Route path="/" element={<Homepage />} />
            <Route path="/campaigns" element={<Campaigns />} />
            <Route path="/athletes" element={<Athletes />} />
            <Route path="/sobre"element={<Sobre />} />
        </Routes>
      </BrowserRouter>
    </>

  );
}

export default App
