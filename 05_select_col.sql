SELECT idCliente,
    qtdePontos, 
    qtdePontos + 10 AS QtdePontosPlus10,  
    qtdePontos * 2, 
        DtCriacao,
        substr(DtCriacao, 1, 10) AS datasubstr,   
        datetime(substr(DtCriacao, 1, 10) ) AS DtCriacaoNova,
        strftime ('%w',  datetime(substr(DtCriacao, 1, 10))) AS DiaDaSemana


FROM clientes