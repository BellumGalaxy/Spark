import './App.css';
import NavBar from './components/NavBar';
import Campaigns from './pages/Campaigns';
import Homepage from './pages/Homepage';
import { BrowserRouter, Routes, Route } from "react-router-dom";

function App() {

  return (
    <>
      <BrowserRouter>
        <NavBar />
        <Routes>
            <Route path="/" element={<Homepage />} />
            <Route path="/campaigns" element={<Campaigns />} />
        </Routes>
      </BrowserRouter>
    </>
  )
}

export default App
