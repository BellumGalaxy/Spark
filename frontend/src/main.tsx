import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import "./styles/fonts.css";
import "./index.css";
import { ThirdwebProvider } from "thirdweb/react";
import {
  createThirdwebClient,
  defineChain,
  getContract,
  resolveMethod,
} from "thirdweb";
import { client } from "./utils/thirdweb.ts";

export const contract = getContract({
  client,
  chain: defineChain(11155111),
  address: "0x581D884490A0151D7d54D5776d3874CBceA80389",
});

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <ThirdwebProvider>
      <App />
    </ThirdwebProvider>
  </React.StrictMode>
);
