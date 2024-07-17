import './App.css';
import Homepage from './pages/Homepage';
import Conta from './components/Conta';
import RegisterConta from './components/RegisterConta';
import { BrowserRouter, Routes, Route } from 'react-router-dom';


function App() {

  return (
    <>
     <BrowserRouter>
        <Routes>
          <Route path="/" element={<RegisterConta />} />
          <Route path="/conta" element={<Conta />} />
        </Routes>
      </BrowserRouter>
    </>

  );
}

export default App
