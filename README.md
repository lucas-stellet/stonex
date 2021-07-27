# Stonex

## Acessando a API online

A API está disponível no endereço abaixo:

[stonex.jaspion.xyz/api](http://stonex.jaspion.xyz/api)

Para facilitar o acesso, alguns usuários e suas respectivas contas, exceto usuários do backoffice, foram criados. Assim como transações do tipo saque ou retirada, que foram persistidas em períodos distintos para ter a possibilidade de visualização de relatórios.

```json
{
  "first_name": "Tony",
  "last_name": "Stark",
  "email": "iron_man@gmail.com",
  "password": "10203040",
  "document": "001.002.003-04"
}

{
  "first_name": "Peter",
  "last_name": "Parker",
  "email": "spider-Man@gmail.com",
  "password": "50607080",
  "document": "005.006.007-08"
}

{
  "first_name": "Nick",
  "last_name": "Fury",
  "email": "nick@shield.com",
  "password": "00102000",
  "document": "000.001.002-00",
  "role": "admin"
}
```

## Rodando localmente

Com a inenção de facilitar a iniclização e o uso da aplicação localmente, criei um setup com Docker.
Para iniciar basta ter o docker e o docker-compose instalados na sua máquina, dessa forma você tera um container Elixir/Phoenix com a aplicação e um database PostgreSQL rodando localmente.
Execute o comando abaixo e aguarde os logs mais abaixo aparecerem em seu terminal.

```bash
docker-compose up
```

```
stonex    | [info] Access StonexWeb.Endpoint at http://localhost:4000
stonex    | [info] POST /api/account/login
```

Com esas informações em tela a sua aplicação estará funcionando e pronto para o acesso.

## Dados para acesso

No momento da criação da aplicação foi configurado para que
alguns usuários fossem inseridos no banco com intuito de agilizar a utilização inicial.

Segue a lista de usuários cadastrados e seus dados.

```elixir

%{
  "first_name" => "Tony",
  "last_name" => "Stark",
  "email" => "iron_man@gmail.com",
  "password" => "10203040",
  "document" => "001.002.003-04"
}

%{
  "first_name" => "Peter",
  "last_name" => "Parker",
  "email" => "spider-Man@gmail.com",
  "password" => "50607080",
  "document" => "005.006.007-08"
}

%{
  "first_name" => "Nick",
  "last_name" => "Fury",
  "email" => "nick@shield.com",
  "password" => "00102000",
  "document" => "000.001.002-00",
  "role" => "admin"
}

```

## Postman collection

Caso você utilize o Postman como interface para enviar requisições para API's, basta acessar o link abaixo que você terá acesso a uma coleção de requisições tanto no ambiente de produção quanto do de desenvolvimento.

### [Stonex Public Workspace Postman](https://www.postman.com/restless-capsule-16017/workspace/stonex/request/9698539-5db7bf56-31ec-4744-94f1-eb3f68f380b2)

## Utilização da API

A API é dividida em três partes:

- Auth
- Backoffice
- Transactions

### Auth

**[POST]** _/api/account/signup_

Criação de novos clientes. Enviando as informações pessoais como por exemplo o primeiro nome e o CPF, você receberá como reposta os dados da sua conta bancária. Ressaltando que o número é gerado de forma aleatório e que o saldo bancário inicial é de R$ 1000.00 .

```json
Exemplo de requisição

{
    "first_name": "Bruce",
    "last_name": "Banner",
    "email": "the_hulk@gmail.com",
    "password": "147852", // Senha entre 6 e 8 caracteres
    "document": "001.002.003-04" // CPF deve ter pontos e virgulas
}
```

```json
Exemplo da resposta

{
    "first_name": "Bruce",
    "last_name": "Banner",
    "email": "the_hulk@gmail.com",
    "password": "147852", // Senha entre 6 e 8 caracteres
    "document": "001.002.003-04" // CPF deve ter pontos e virgulas
}
```

**[POST]** _/api/account/login_

Login de clientes com conta bancária. Só será possível realizar transações, de qualquer natureza, após logar, receber um token e utiliza-lo nas chamadas a API.

```json
Exemplo de requisição

{

    "document": "001.002.003-04",
    "password": "10203040"

}
```

```json
Exemplo da resposta

{
    "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9 ..."
}
```

## Transactions

**[POST]** _/api/transaction/transfer_

Realiza transferências a partir da conta do usuário logado para o beneficiário escolhido.

```json
Exemplo de requisição

{
    "account": {
        "branch": "0001",
        "number": "895591",
        "digit": "2"
    },
    "document": "005.006.007-08",
    "value": 100.00 // Padrões permitidios: "100.00", 100.00, 100
}
```

```json
Exemplo da resposta

{
    "message": "Transfer done successfully!"
}
```

**[POST]** _/api/transaction/withdraw_

Realiza saques a partir da conta do usuário logado.

```json
Exemplo de requisição

{
    "value": 100.00 // Padrões permitidios: "100.00", 100.00, 100
}
```

```json
Exemplo da resposta

{
    "message": "Withdraw done successfully!"
}
```

## Backoffice

**[POST]** _/api/backoffice/user_

Cria um novo usuário com privilégios administrativos.
No entanto, apenas usuários logados no backoffice podem
criar novos usuários com tais privilégios.

```json
Exemplo de requisição

{
    "first_name": "Natasha",
    "last_name": "Romanov",
    "email": "black_widow@gmail.com",
    "password": "36985214",
    "document": "007.700.070-77"
}
```

```json
Exemplo da resposta

{
    "message": "Account created!"
}
```

**[POST]** _/api/backoffice/login_

Loga usuários do backoffice e retorna um token necessário para o acesso das demais rotas do mesmo.

```json
Exemplo de requisição

{
    "document": "000.001.002-00",
    "password": "00102000"
}
```

```json
Exemplo da resposta

{
    "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9..."
}
```

**[GET]** _/api/backoffice/reports_

Retorna relatório de todas as transações de 5 maneiras:

- relatório do dia [daily]
- relatório do mês [monthly]
- relatório do ano [annual]
- relatório total [total]
- relatóio de um período específico, `from date to date`

Para escolher o tipo de relatório basta enviar a requisição
como nos exemplos abaixo:

```http
base_url = localhost:4000/api || stonex.jaspion.xyz/api

{{ base_url }}/backoffice/reports/?type=daily

{{ base_url }}/backoffice/reports/?type=monthly

{{ base_url }}/backoffice/reports/?type=annual

{{ base_url }}/backoffice/reports/?type=total

{{ base_url }}/backoffice/reports/?type=monthly&from=2021-01-01&to=2021-07-26
```

```json
Exemplo da resposta

{
    "data": "Total transacted: R$ 520.00"
}
```
