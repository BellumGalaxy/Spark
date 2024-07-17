import { useReadContract } from "thirdweb/react";
import { client } from "../utils/client";
import { getContract } from "thirdweb";
import { sepolia } from "thirdweb/chains";

const contract = getContract({
  client,
  chain: sepolia,
  address: "0x9698D1A7ACBE4C1632815A385Ca9C197f3BB7062",
});

export default function Owner() {
  const { data, isLoading } = useReadContract({
    contract,
    method: "function owner() view returns (address)",
    params: [],
  });

  return (
    <p
      style={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        margin: "2em",
        fontWeight: "bold",
        textAlign: "center",
      }}
    >
      Owner {data}
    </p>
  );
}
