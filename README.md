# <p align="center"> Spark

</p>

<p align="center"> Blockchain Rio Hackathon
</p>

<p align="center">
  <img src="https://blogger.googleusercontent.com/img/a/AVvXsEi5AqEnj4RnB3s5ShGd3-Vo2yEY8Iy1Erv1tqaW1yM3kViW-SCATQ3CDoWFT0kYV3kGwBLbnl70XZYBjuvEwjO7E-MqoigGzKAhQrAURHYOHTLiTcpWJ47QUCBh6SpuEK3URLRJoiIufCkBbO-VTY75BnGWJduwZwN_lbVW3Vfjyd8LYifLN2bMFt4IvNw=s16000" width = 500>
</p>

### Links
- Veja o vídeo sobre o projeto disponível [aqui]()
- Live demo [website]()

</br>

### Sobre a Bellum Galaxy
Somos uma comunidade educacional, científica e tecnológica, quebrando barreiras e desmistificando a tecnologia. Nossa missão é capacitar indivíduos para o crescimento pessoal e coletivo. Para isso proporcionamos oportunidades de aprendizado e desenvolvimento na nossa comunidade, onde as contribuições alimentam a inovação e impulsionam mudanças positivas..

</br>

<p align="center">
  <img width="16%" src="https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjDzC6qHOPXlQGVwQsz9J8IyLkIzbGDPkz08C7dzO06VeKkmluZJ0ollUVgwwvjteBLIPRn0BsZxJGr8S4Tfov7s5Oc8M8nxsTHa4VxamXvW5KGhXfbnVrkL5kESHmag0URch49nz0BTjGL3GbtqMXO0ULYhJbUSQfi2hmSNinyyUVmZyw_ZWBCpdRh5_Q/s16000/Logo-BG-1-semfundo.png">
</p>
</br>

Junte-se à nossa comunidade no [Discord](https://discord.com/invite/H2UpdzbbRJ) e, juntos, moldemos o futuro com a tecnologia blockchain.

</br>

## Sobre

Integrando Web2 e Web3, Spark permite que qualquer PF ou PJ realize doações ou passe a patrocinar atletas cadastrados em nossa plataforma. Entretanto, para realizar doações ou recebê-las, é necessário validar sua identidade off-chain usando o validador do Gov.br. Uma vez validado, a sua identidade on-chain poderá ser criada.

Para garantir que ambas identidades estão atreladas, utilizamos o Chainlink Functions para realizar a verificação. Após verificação o usuário estará ápto a utilizar a plataforma.

Com o intuito de fomentar a participação da comunidade, uma taxa em BPS é recolhida. O valor recolhido é direcionado à um 'fundo'. Uma vez no mês, um sorteio será realizado utilizando Automations e VRF para distribuir o valor arrecadado para um dos doadores.

</br>

## Como Funciona

Nosso sistema funciona a partir da atuação de três atores principais: Atletas, Doadores e Patrocinadores.

Atletas são o foco do projeto. O objetivo é aproximá-los da população, condensando suas conquistas, sua carreira e suas necessidades de modo o povo brasileiro ajude-o a levar o Brasil ao todo com um processo de doação de poucos cliques. Além disso, trazemos a possibilidade da criação de Campanhas por objetivos específicos. Seja para compra de novos materiais esportivos, viagens, custos de vida.

Doadores tem a liberdade para acessar nosso site, escolher qual atleta gostaria de ajudar e fazer a doação direta usando USDC.

Patrocinadores adquirem pacotes de patrocínio para os atletas aos quais entendem que terão maior retorno. Entretanto, para efetivamente direcionar o valor para o atleta desejado, precisam adquirir Sparks.

Sparks é o token do protocolo que dá liberdade para os patrocinadores para acumularem pontos de patrocínio e distribuírem no momento oportuno. Facilitando a alocação de recursos para abatimento de impostos mesmo em momentos onde não seja interessante investir em um atleta.

O montante recebido através de patrocínio passará por validação para o saque. Ou seja, o atleta precisará prestar contas aos seus apoiadores para realizar o saque.

</br>

## Soluções Chainlink

### Chainlink Functions

https://github.com/BellumGalaxy/Spark/blob/b79f6beebd9056dbca07fd231fd358269da15cd2/SmartContracts/src/Spark.sol#L216-L223

https://github.com/BellumGalaxy/Spark/blob/b79f6beebd9056dbca07fd231fd358269da15cd2/SmartContracts/src/Spark.sol#L246-L252

https://github.com/BellumGalaxy/Spark/blob/b79f6beebd9056dbca07fd231fd358269da15cd2/SmartContracts/src/Spark.sol#L273-L277

https://github.com/BellumGalaxy/Spark/blob/b79f6beebd9056dbca07fd231fd358269da15cd2/SmartContracts/src/Spark.sol#L417-L432

https://github.com/BellumGalaxy/Spark/blob/b79f6beebd9056dbca07fd231fd358269da15cd2/SmartContracts/src/Spark.sol#L441-L461

</br>

### Verifiable Random Function

https://github.com/BellumGalaxy/Spark/blob/b79f6beebd9056dbca07fd231fd358269da15cd2/SmartContracts/src/Spark.sol#L389-L412

https://github.com/BellumGalaxy/Spark/blob/b79f6beebd9056dbca07fd231fd358269da15cd2/SmartContracts/src/Spark.sol#L470-L481

</br>

### Automation

Time Based: 

</br>

## Próximos Passos

- Desenvolver algoritmo para ranqueamento de atletas de modo que a exposição que esse atleta traga para seus patrocinadores seja recompensada proporcionalmente.
- Inclusão de doações e patrocínio cross-chain.
- Inclusão de novos Tokens para doações e compra de Sparks.
- Sistema de verificação de Notas para liberação do valor recebido de acordos de patrocínio.
