CREATE SCHEMA Dimensional;

CREATE TABLE Dimensional.DimensaoVendedor(
  ChaveVendedor int PRIMARY KEY,
  IDVendedor int,
  Nome Varchar(50),
  DataInicioValidade date not null,
  DataFimValidade date
);


CREATE TABLE Dimensional.DimensaoCliente(
  ChaveCliente int  PRIMARY KEY,
  IDCliente int,
  Cliente Varchar(50),
  Estado Varchar(2),
  Sexo Char(1),
  Status Varchar(50),
  DataInicioValidade date not null,
  DataFimValidade date
);


CREATE TABLE Dimensional.DimensaoProduto(
  ChaveProduto int  PRIMARY KEY,
  IDProduto int,
  Produto Varchar(100),
  DataInicioValidade date not null,
  DataFimValidade date
);

CREATE TABLE Dimensional.DimensaoTempo(
  ChaveTempo int PRIMARY KEY,
  Data Date,
  Dia int,
  Mes int,
  Ano int,
  DiaSemana int,
  Trimestre int
);


CREATE TABLE Dimensional.FatoVendas(
  ChaveVendas int  PRIMARY KEY,
  ChaveVendedor int references Dimensional.DimensaoVendedor (ChaveVendedor),
  ChaveCliente int references Dimensional.DimensaoCliente (ChaveCliente),
  ChaveProduto int references Dimensional.DimensaoProduto (ChaveProduto),
  ChaveTempo int references Dimensional.DimensaoTempo (ChaveTempo),
  Quantidade int,
  ValorUnitario Numeric(10,2),
  ValorTotal Numeric(10,2),
  Desconto Numeric(10,2)
);