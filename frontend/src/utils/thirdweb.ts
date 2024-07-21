import { createThirdwebClient, getContract, defineChain } from "thirdweb";

// Replace this with your client ID string
// refer to https://portal.thirdweb.com/typescript/v5/client on how to get a client ID
const clientId = import.meta.env.VITE_CLIENT_ID;

if (!clientId) {
  throw new Error("No client ID provided");
}

export const client = createThirdwebClient({
  clientId: clientId,
});

export const contract = getContract({ 
  client, 
  chain: defineChain(11155111),
  address: "0x581D884490A0151D7d54D5776d3874CBceA80389" 
});