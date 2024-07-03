    # Use uma imagem Node.js como base
    FROM node:20
    
    # Define o diretório de trabalho dentro do container
    WORKDIR /app
    
    # Copia o package.json e o package-lock.json para o diretório de trabalho
    COPY package*.json ./
    
    # Instala as dependências do projeto
    RUN npm install
    
    # Copia o restante do código da aplicação
    COPY . .
    
    # Compila a aplicação
    RUN npm run build
    
    # Expõe a porta que a aplicação vai rodar
    EXPOSE 3000
    
    # Define o comando para iniciar a aplicação
    CMD ["npm", "run", "start:prod"]