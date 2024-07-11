import './App.css';
import Athletes from './pages/Athletes';
import Campaigns from './pages/Campaigns';
import Homepage from './pages/Homepage';
import Sobre from './pages/Sobre';
import { BrowserRouter, Routes, Route } from "react-router-dom";


function App() {

  return (
    <>
      <BrowserRouter>
        <Routes>
            <Route path="/" element={<Homepage />} />
            <Route path="/campaigns" element={<Campaigns />} />
            <Route path="/athletes" element={<Athletes />} />
            <Route path="/sobre"element={<Sobre />} />
        </Routes>
      </BrowserRouter>
    </>
  )
}

export default App
