function TFrmConcBancaria.LancManual(QryIns, QryInsFlx, QryUpdFlx: TSQLQuery):Integer;
var
  CodConciliado, NumBordero, CodChaveBco, vCodChaveFlx, vCodChaveMovCta: Integer;
begin
  try
    CodConciliado := 0;
    NumBordero    := 0;
    CodChaveBco   := 0;
    if CliMemoryFLG_FLUXO.AsString = 'S' then
    begin
      CodChaveBco := DMTabelaX.RetornaProxCOD_CHAVE_MOVBCO;

      CliMemTit.Filter   := 'COD_INTERNO = ' + IntToStr(CliMemory.RecNo);
      CliMemTit.Filtered := True;
      CliMemTit.First;

      while not CliMemTit.Eof do
      begin
        CliMemEv.Filter   := 'COD_INTERNO = ' + IntToStr(CliMemTitCOD_CHAVE.AsInteger);
        CliMemEv.Filtered := True;
        CliMemEv.First;

        if CliMemTitCOD_CHAVE.AsInteger > 0 then
          with QryUpdFlx do
          begin
            LimpaParamSQLQry(QryUpdFlx);
            SQL.Add(GetSQLManualUpdFlx);

            ParamByName('DATA').AsDate                := CliMemTitDTA_PGTO.AsDateTime;
            if CodConciliado = 0 then
            begin
              ParamByName('COD_CONCILIADO').AsInteger := DMTabelaX.BuscaProxCodigo('COD_CONCILIADO');
              CodConciliado                           := ParamByName('COD_CONCILIADO').AsInteger;
            end
            else
              ParamByName('COD_CONCILIADO').AsInteger := CodConciliado;
            if NumBordero = 0 then
            begin
              ParamByName('NUM_BORDERO').AsInteger := DMTabelaX.BuscaProxCodigo('COD_BORDERO');
              NumBordero                           := ParamByName('NUM_BORDERO').AsInteger;
            end
            else
              ParamByName('NUM_BORDERO').AsInteger := NumBordero;

            ParamByName('VAL_DESCONTO').AsFloat    := SomaEventos(1);
            ParamByName('VAL_JUROS').AsFloat       := SomaEventos(2);
            ParamByName('VAL_DEVOLUCAO').AsFloat   := SomaEventos(3);
            ParamByName('VAL_CREDITO').AsFloat     := SomaEventos(4);
            ParamByName('VAL_RETENCAO').AsFloat    := SomaEventos(5);
            ParamByName('VAL_TAXA_ADM').AsFloat    := SomaEventos(6);
            ParamByName('VAL_OUTROS').AsFloat      := SomaEventos(7);

            ParamByName('COD_CHAVE').AsInteger     := CliMemTitCOD_CHAVE.AsInteger;

            ParamByName('COD_BANCO_PGTO').AsInteger:= FramSelBcoCC.CliBancoCOD_BANCO.AsInteger;
            ParamByName('DES_CC').AsString         := FramSelBcoCC.CliCCDES_CC.AsString;
            ExecSQL;

            if ParamByName('VAL_OUTROS').AsFloat <> 0.00 then
              AddEvCartao(0);

            FluxoLote(CliMemTitCOD_CHAVE.AsInteger, CodChaveBco);
          end
        else
          with QryInsFlx do
          begin
            LimpaParamSQLQry(QryInsFlx);
            SQL.Add(GetSQLManualFlx);

            vCodChaveFlx := DMTabelaX.RetornaProxCOD_CHAVE;

            ParamByName('VAL_PARCELA').AsFloat        := CliMemTitVAL_BRUTO.AsFloat;
            ParamByName('VAL_TOTAL_NF').AsFloat       := CliMemTitVAL_BRUTO.AsFloat;
            ParamByName('TIPO_PARCEIRO').AsInteger    := CliMemTitTIPO_PARCEIRO.AsInteger;
            ParamByName('COD_PARCEIRO').AsInteger     := CliMemTitCOD_PARCEIRO.AsInteger;
            ParamByName('DES_PARCEIRO').AsString      := CliMemTitDES_PARCEIRO.AsString;
            ParamByName('NUM_CGC_CPF').AsString       := CliMemTitNUM_CGC_CPF.AsString;
            ParamByName('COD_ENTIDADE').AsInteger     := CliMemTitCOD_ENTIDADE.AsInteger;
            ParamByName('COD_LOJA').AsInteger         := CliMemTitCOD_LOJA.AsInteger;
            ParamByName('DTA_ENTRADA').AsDateTime     := CliMemTitDTA_ENTRADA.AsDateTime;
            if CliMemTitCOD_BANCO_FATURA.AsInteger <= 0 then
            begin
              ParamByName('COD_BANCO').AsInteger      := 0;
              ParamByName('COD_BANCO').Clear;
            end
            else
              ParamByName('COD_BANCO').AsInteger      := CliMemTitCOD_BANCO_FATURA.AsInteger;
            ParamByName('DTA_VENCIMENTO').AsDateTime  := CliMemTitDTA_VENCIMENTO.AsDateTime;
            ParamByName('NUM_CONDICAO').AsInteger     := CliMemTitNUM_CONDICAO.AsInteger;
            ParamByName('COD_CONDICAO').AsInteger     := CliMemTitCOD_CONDICAO.AsInteger;
            ParamByName('TIPO_CONTA').AsInteger       := CliMemTitTIPO_CONTA.AsInteger;
            ParamByName('DTA_EMISSAO').AsDateTime     := CliMemTitDTA_EMISSAO.AsDateTime;
            ParamByName('NUM_DOCTO').AsString         := CliMemTitNUM_DOCTO.AsString;
            ParamByName('COD_CATEGORIA').AsInteger    := CliMemTitCOD_CATEGORIA.AsInteger;
            ParamByName('COD_SUBCATEGORIA').AsInteger := CliMemTitCOD_SUBCATEGORIA.AsInteger;
            ParamByName('NUM_PARCELA').AsInteger      := 1;
            ParamByName('QTD_PARCELA').AsInteger      := 1;
            ParamByName('COD_BANCO_PGTO').AsInteger   := FramSelBcoCC.CliBancoCOD_BANCO.AsInteger;
            ParamByName('DES_OBSERVACAO').AsString    := 'Título gerado a partir do lançamento manual na tela de conciliação bancária';

            if CodConciliado = 0 then
            begin
              ParamByName('COD_CONCILIADO').AsInteger := DMTabelaX.BuscaProxCodigo('COD_CONCILIADO');
              CodConciliado                           := ParamByName('COD_CONCILIADO').AsInteger;
            end
            else
              ParamByName('COD_CONCILIADO').AsInteger := CodConciliado;

            if NumBordero = 0 then
            begin
              ParamByName('NUM_BORDERO').AsInteger    := DMTabelaX.BuscaProxCodigo('COD_BORDERO');
              NumBordero                              := ParamByName('NUM_BORDERO').AsInteger;
            end
            else
              ParamByName('NUM_BORDERO').AsInteger    := NumBordero;
            ParamByName('COD_CHAVE').AsInteger        := vCodChaveFlx;
            ParamByName('DATA').AsDate                := CliMemTitDTA_PGTO.AsDateTime;
            ParamByName('DES_CC').AsString            := FramSelBcoCC.CliCCDES_CC.AsString;
            ParamByName('VAL_DESCONTO').AsFloat       := SomaEventos(1);
            ParamByName('VAL_JUROS').AsFloat          := SomaEventos(2);
            ParamByName('VAL_DEVOLUCAO').AsFloat      := SomaEventos(3);
            ParamByName('VAL_CREDITO').AsFloat        := SomaEventos(4);
            ParamByName('VAL_RETENCAO').AsFloat       := SomaEventos(5);
            ParamByName('VAL_TAXA_ADM').AsFloat       := SomaEventos(6);
            ParamByName('VAL_OUTROS').AsFloat         := SomaEventos(7);

            if CliMemTitCOD_CONTA.AsInteger > 0 then
              ParamByName('COD_CONTA').AsInteger := CliMemTitCOD_CONTA.AsInteger
            else
            begin
              ParamByName('COD_CONTA').AsInteger := 0;
              ParamByName('COD_CONTA').Clear;
            end;

            ExecSQL;

            if ParamByName('VAL_OUTROS').AsFloat <> 0.00 then
              AddEvCartao(vCodChaveFlx);

            FluxoLote(vCodChaveFlx, CodChaveBco);
          end;
        CliMemTit.Next;
      end;
    end;

    with QryIns do
    begin
      LimpaParamSQLQry(QryIns);
      SQL.Add(GetSQLManualBco);

      if (CliMemoryCOD_BANCO_TRAN.AsInteger > 0) and (CliMemoryFLG_FLUXO.AsString = 'N') then
      begin
        vCodChaveMovCta := DmTabelaX.RetornaProxCodChaveMovCta;

        if CliMemoryTIPO_OPERACAO.AsInteger = 1 then //Débito
        begin
          ParamByName('COD_LOJA').AsInteger       := FramSelBcoCC.CliCCCOD_LOJA.AsInteger;
          ParamByName('COD_BANCO_PGTO').AsInteger := FramSelBcoCC.CliBancoCOD_BANCO.AsInteger;
          ParamByName('DES_CC').AsString          := FramSelBcoCC.CliCCDES_CC.AsString;
          ParamByName('COD_BANCO_TRAN').AsInteger := CliMemoryCOD_BANCO_TRAN.AsInteger;
          ParamByName('DES_CC_TRAN').AsString     := CliMemoryDES_CC_TRAN.AsString;
          ParamByName('TIPO_MOVTO').AsInteger     := 2;
          ParamByName('TIPO_SITUACAO').AsInteger  := CliMemoryCOMPENSAR.AsInteger;
          ParamByName('NUM_DOCTO_PGTO').AsString  := CliMemoryNUM_DOCTO_PGTO.AsString;
          ParamByName('VAL_DOCTO').AsCurrency     := CliMemoryVAL_DOCTO.AsFloat;
          ParamByName('DTA_PGTO').AsDate          := CliMemoryDTA_PGTO.AsDateTime;
          ParamByName('DTA_ENTRADA').AsDate       := Date;
          if CodConciliado > 0 then
            ParamByName('COD_CONCILIADO').AsInteger := CodConciliado
          else
          begin
            ParamByName('COD_CONCILIADO').AsInteger := 0;
            ParamByName('COD_CONCILIADO').Clear;
          end;
          if NumBordero > 0 then
            ParamByName('FAVORECIDO').AsString    := Copy(Copy(CliMemoryFAVORECIDO.AsString,1,38) + ' BORD.:' + IntToStr(NumBordero),1,50)
          else
            ParamByName('FAVORECIDO').AsString    := Copy(CliMemoryFAVORECIDO.AsString,1,50);
          ParamByName('TIPO_OPERACAO').AsInteger  := CliMemoryTIPO_OPERACAO.AsInteger;
          if CliMemoryFLG_FLUXO.AsString = 'S' then
          begin
            ParamByName('COD_CATEGORIA').AsInteger   := 0;
            ParamByName('COD_CATEGORIA').Clear;
            ParamByName('COD_SUBCATEGORIA').AsInteger:= 0;
            ParamByName('COD_SUBCATEGORIA').Clear;
            ParamByName('COD_CHAVE').AsInteger     := CodChaveBco;
            ParamByName('COD_CHAVE_MOV_CTA').AsInteger := 0;
            ParamByName('COD_CHAVE_MOV_CTA').Clear;

            ParamByName('DES_OBSERVACAO').AsString := CliMemoryDES_OBSERVACAO.AsString + IntToStr(NumBordero);
            ParamByName('COD_CONTA').AsInteger     := 0;
            ParamByName('COD_CONTA').Clear;
            EditaCliMemoryChave(ParamByName('COD_CHAVE').AsInteger,0);
          end
          else
          begin
            ParamByName('COD_CATEGORIA').AsInteger   := CliMemoryCOD_CATEGORIA.AsInteger;
            ParamByName('COD_SUBCATEGORIA').AsInteger:= CliMemoryCOD_SUBCATEGORIA.AsInteger;
            ParamByName('COD_CHAVE').AsInteger       := 0;
            ParamByName('COD_CHAVE').Clear;
            ParamByName('COD_CHAVE_MOV_CTA').AsInteger := vCodChaveMovCta;
            EditaCliMemoryChave(0,ParamByName('COD_CHAVE_MOV_CTA').AsInteger);
            ParamByName('DES_OBSERVACAO').AsString   := CliMemoryDES_OBSERVACAO.AsString;
            (*Somente se a SubCategoria possuir conta contábil vinculada a mesma*)
            if CliMemoryCOD_CONTA.AsInteger > 0 then
              ParamByName('COD_CONTA').AsInteger     := CliMemoryCOD_CONTA.AsInteger
            else
            begin
              ParamByName('COD_CONTA').AsInteger     := 0;
              ParamByName('COD_CONTA').Clear;
            end;
          end;
          ParamByName('FLG_FLUXO').AsString          := CliMemoryFLG_FLUXO.AsString;
          ParamByName('NUM_REGISTRO').AsInteger      := DMTabelaX.RetornaProxNUM_REGISTRO_MOVBCO;
          ExecSQL;

          Result := ParamByName('NUM_REGISTRO').AsInteger;

          ParamByName('COD_LOJA').AsInteger       := FramSelBcoCC.CliCCCOD_LOJA.AsInteger;
          ParamByName('COD_BANCO_PGTO').AsInteger := CliMemoryCOD_BANCO_TRAN.AsInteger;
          ParamByName('DES_CC').AsString          := CliMemoryDES_CC_TRAN.AsString;
          ParamByName('COD_BANCO_TRAN').AsInteger := FramSelBcoCC.CliBancoCOD_BANCO.AsInteger;
          ParamByName('DES_CC_TRAN').AsString     := FramSelBcoCC.CliCCDES_CC.AsString;
          ParamByName('TIPO_SITUACAO').AsInteger  := CliMemoryCOMPENSAR.AsInteger;
          ParamByName('NUM_DOCTO_PGTO').AsString  := CliMemoryNUM_DOCTO_PGTO.AsString;
          ParamByName('VAL_DOCTO').AsCurrency     := CliMemoryVAL_DOCTO.AsFloat;
          ParamByName('DTA_PGTO').AsDate          := CliMemoryDTA_PGTO.AsDateTime;
          ParamByName('DTA_ENTRADA').AsDate       := Date;
          if CodConciliado > 0 then
            ParamByName('COD_CONCILIADO').AsInteger := CodConciliado
          else
          begin
            ParamByName('COD_CONCILIADO').AsInteger := 0;
            ParamByName('COD_CONCILIADO').Clear;
          end;
          ParamByName('FAVORECIDO').AsString       := Copy(CliMemoryFAVORECIDO_TRAN.AsString,1,50);
          ParamByName('TIPO_MOVTO').AsInteger      := 2;
          ParamByName('TIPO_OPERACAO').AsInteger   := iif(CliMemoryTIPO_OPERACAO.AsInteger = 0, 1, 0);
          ParamByName('COD_CATEGORIA').AsInteger   := CliMemoryCOD_CAT_ESTORNO.AsInteger;
          ParamByName('COD_SUBCATEGORIA').AsInteger:= CliMemoryCOD_SUBCAT_ESTORNO.AsInteger;
          ParamByName('COD_CHAVE').AsInteger       := 0;
          ParamByName('COD_CHAVE').Clear;
          ParamByName('DES_OBSERVACAO').AsString   := CliMemoryDES_OBSERVACAO.AsString;
          (*Somente se a SubCategoria possuir conta contábil vinculada a mesma*)
          if CliMemoryCOD_CONTA.AsInteger > 0 then
            ParamByName('COD_CONTA').AsInteger := CliMemoryCOD_CONTA_TRAN.AsInteger
          else
          begin
            ParamByName('COD_CONTA').AsInteger     := 0;
            ParamByName('COD_CONTA').Clear;
          end;
          ParamByName('FLG_FLUXO').AsString        := 'N';
          ParamByName('NUM_REGISTRO').AsInteger    := DMTabelaX.RetornaProxNUM_REGISTRO_MOVBCO;
          ParamByName('COD_CHAVE_MOV_CTA').AsInteger := vCodChaveMovCta;
          EditaCliMemoryChave(0,ParamByName('COD_CHAVE_MOV_CTA').AsInteger);
          ExecSQL;
        end
        else
        begin
          ParamByName('COD_LOJA').AsInteger       := FramSelBcoCC.CliCCCOD_LOJA.AsInteger;
          ParamByName('COD_BANCO_PGTO').AsInteger := CliMemoryCOD_BANCO_TRAN.AsInteger;
          ParamByName('DES_CC').AsString          := CliMemoryDES_CC_TRAN.AsString;
          ParamByName('COD_BANCO_TRAN').AsInteger := FramSelBcoCC.CliBancoCOD_BANCO.AsInteger;
          ParamByName('DES_CC_TRAN').AsString     := FramSelBcoCC.CliCCDES_CC.AsString;
          ParamByName('TIPO_SITUACAO').AsInteger  := CliMemoryCOMPENSAR.AsInteger;
          ParamByName('NUM_DOCTO_PGTO').AsString  := CliMemoryNUM_DOCTO_PGTO.AsString;
          ParamByName('VAL_DOCTO').AsCurrency     := CliMemoryVAL_DOCTO.AsFloat;
          ParamByName('DTA_PGTO').AsDate          := CliMemoryDTA_PGTO.AsDateTime;
          ParamByName('DTA_ENTRADA').AsDate       := Date;
          if CodConciliado > 0 then
            ParamByName('COD_CONCILIADO').AsInteger := CodConciliado
          else
          begin
            ParamByName('COD_CONCILIADO').AsInteger := 0;
            ParamByName('COD_CONCILIADO').Clear;
          end;
          ParamByName('FAVORECIDO').AsString       := Copy(CliMemoryFAVORECIDO_TRAN.AsString,1,50);
          ParamByName('TIPO_MOVTO').AsInteger      := 2;
          ParamByName('TIPO_OPERACAO').AsInteger   := iif(CliMemoryTIPO_OPERACAO.AsInteger = 0, 1, 0);
          ParamByName('COD_CATEGORIA').AsInteger   := CliMemoryCOD_CAT_ESTORNO.AsInteger;
          ParamByName('COD_SUBCATEGORIA').AsInteger:= CliMemoryCOD_SUBCAT_ESTORNO.AsInteger;
          ParamByName('COD_CHAVE').AsInteger       := 0;
          ParamByName('COD_CHAVE').Clear;
          ParamByName('DES_OBSERVACAO').AsString   := CliMemoryDES_OBSERVACAO.AsString;
          (*Somente se a SubCategoria possuir conta contábil vinculada a mesma*)
          if CliMemoryCOD_CONTA.AsInteger > 0 then
            ParamByName('COD_CONTA').AsInteger := CliMemoryCOD_CONTA_TRAN.AsInteger
          else
          begin
            ParamByName('COD_CONTA').AsInteger     := 0;
            ParamByName('COD_CONTA').Clear;
          end;
          ParamByName('FLG_FLUXO').AsString        := 'N';
          ParamByName('NUM_REGISTRO').AsInteger    := DMTabelaX.RetornaProxNUM_REGISTRO_MOVBCO;
          ParamByName('COD_CHAVE_MOV_CTA').AsInteger := vCodChaveMovCta;
          EditaCliMemoryChave(0,ParamByName('COD_CHAVE_MOV_CTA').AsInteger);
          ExecSQL;

          ParamByName('COD_LOJA').AsInteger       := FramSelBcoCC.CliCCCOD_LOJA.AsInteger;
          ParamByName('COD_BANCO_PGTO').AsInteger := FramSelBcoCC.CliBancoCOD_BANCO.AsInteger;
          ParamByName('DES_CC').AsString          := FramSelBcoCC.CliCCDES_CC.AsString;
          ParamByName('COD_BANCO_TRAN').AsInteger := CliMemoryCOD_BANCO_TRAN.AsInteger;
          ParamByName('DES_CC_TRAN').AsString     := CliMemoryDES_CC_TRAN.AsString;
          ParamByName('TIPO_MOVTO').AsInteger     := 2;
          ParamByName('TIPO_SITUACAO').AsInteger  := CliMemoryCOMPENSAR.AsInteger;
          ParamByName('NUM_DOCTO_PGTO').AsString  := CliMemoryNUM_DOCTO_PGTO.AsString;
          ParamByName('VAL_DOCTO').AsCurrency     := CliMemoryVAL_DOCTO.AsFloat;
          ParamByName('DTA_PGTO').AsDate          := CliMemoryDTA_PGTO.AsDateTime;
          ParamByName('DTA_ENTRADA').AsDate       := Date;
          if CodConciliado > 0 then
            ParamByName('COD_CONCILIADO').AsInteger := CodConciliado
          else
          begin
            ParamByName('COD_CONCILIADO').AsInteger := 0;
            ParamByName('COD_CONCILIADO').Clear;
          end;
          if NumBordero > 0 then
            ParamByName('FAVORECIDO').AsString    := Copy(Copy(CliMemoryFAVORECIDO.AsString,1,38) + ' BORD.:' + IntToStr(NumBordero),1,50)
          else
            ParamByName('FAVORECIDO').AsString    := Copy(CliMemoryFAVORECIDO.AsString,1,50);
          ParamByName('TIPO_OPERACAO').AsInteger  := CliMemoryTIPO_OPERACAO.AsInteger;
          if CliMemoryFLG_FLUXO.AsString = 'S' then
          begin
            ParamByName('COD_CATEGORIA').AsInteger   := 0;
            ParamByName('COD_CATEGORIA').Clear;
            ParamByName('COD_SUBCATEGORIA').AsInteger:= 0;
            ParamByName('COD_SUBCATEGORIA').Clear;
            ParamByName('COD_CHAVE').AsInteger     := CodChaveBco;
            ParamByName('DES_OBSERVACAO').AsString := CliMemoryDES_OBSERVACAO.AsString + IntToStr(NumBordero);
            ParamByName('COD_CONTA').AsInteger     := 0;
            ParamByName('COD_CONTA').Clear;
          end
          else
          begin
            ParamByName('COD_CATEGORIA').AsInteger   := CliMemoryCOD_CATEGORIA.AsInteger;
            ParamByName('COD_SUBCATEGORIA').AsInteger:= CliMemoryCOD_SUBCATEGORIA.AsInteger;
            ParamByName('COD_CHAVE').AsInteger       := 0;
            ParamByName('COD_CHAVE').Clear;
            ParamByName('DES_OBSERVACAO').AsString   := CliMemoryDES_OBSERVACAO.AsString;
            (*Somente se a SubCategoria possuir conta contábil vinculada a mesma*)
            if CliMemoryCOD_CONTA.AsInteger > 0 then
              ParamByName('COD_CONTA').AsInteger     := CliMemoryCOD_CONTA.AsInteger
            else
            begin
              ParamByName('COD_CONTA').AsInteger     := 0;
              ParamByName('COD_CONTA').Clear;
            end;
          end;
          ParamByName('FLG_FLUXO').AsString          := CliMemoryFLG_FLUXO.AsString;
          ParamByName('NUM_REGISTRO').AsInteger      := DMTabelaX.RetornaProxNUM_REGISTRO_MOVBCO;
          ParamByName('COD_CHAVE_MOV_CTA').AsInteger := vCodChaveMovCta;
          EditaCliMemoryChave(0,ParamByName('COD_CHAVE_MOV_CTA').AsInteger);
          ExecSQL;

          Result := ParamByName('NUM_REGISTRO').AsInteger;
        end;

      end
      else
      begin
        ParamByName('COD_LOJA').AsInteger       := FramSelBcoCC.CliCCCOD_LOJA.AsInteger;
        ParamByName('COD_BANCO_PGTO').AsInteger := FramSelBcoCC.CliBancoCOD_BANCO.AsInteger;
        ParamByName('DES_CC').AsString          := FramSelBcoCC.CliCCDES_CC.AsString;
        ParamByName('COD_BANCO_TRAN').AsInteger := 0;
        ParamByName('COD_BANCO_TRAN').Clear;
        ParamByName('DES_CC_TRAN').AsString     := ' ';
        ParamByName('DES_CC_TRAN').Clear;
        ParamByName('TIPO_MOVTO').AsInteger   := iif(CliMemoryTIPO_OPERACAO.AsInteger = 0, 1, 0);
        ParamByName('TIPO_SITUACAO').AsInteger  := CliMemoryCOMPENSAR.AsInteger;
        ParamByName('NUM_DOCTO_PGTO').AsString  := CliMemoryNUM_DOCTO_PGTO.AsString;
        ParamByName('VAL_DOCTO').AsCurrency     := CliMemoryVAL_DOCTO.AsFloat;
        ParamByName('DTA_PGTO').AsDate          := CliMemoryDTA_PGTO.AsDateTime;
        ParamByName('DTA_ENTRADA').AsDate       := Date;
        if CodConciliado > 0 then
          ParamByName('COD_CONCILIADO').AsInteger := CodConciliado
        else
        begin
          ParamByName('COD_CONCILIADO').AsInteger := 0;
          ParamByName('COD_CONCILIADO').Clear;
        end;
        if NumBordero > 0 then
          ParamByName('FAVORECIDO').AsString    := Copy(Copy(CliMemoryFAVORECIDO.AsString,1,38) + ' BORD.:' + IntToStr(NumBordero),1,50)
        else
          ParamByName('FAVORECIDO').AsString    := Copy(CliMemoryFAVORECIDO.AsString,1,50);
        ParamByName('TIPO_OPERACAO').AsInteger  := CliMemoryTIPO_OPERACAO.AsInteger;
        if CliMemoryFLG_FLUXO.AsString = 'S' then
        begin
          ParamByName('COD_CATEGORIA').AsInteger   := 0;
          ParamByName('COD_CATEGORIA').Clear;
          ParamByName('COD_SUBCATEGORIA').AsInteger:= 0;
          ParamByName('COD_SUBCATEGORIA').Clear;
          ParamByName('COD_CHAVE').AsInteger     := CodChaveBco;
          ParamByName('COD_CHAVE_MOV_CTA').AsInteger := 0;
          ParamByName('COD_CHAVE_MOV_CTA').Clear;
          ParamByName('DES_OBSERVACAO').AsString := CliMemoryDES_OBSERVACAO.AsString + IntToStr(NumBordero);
          ParamByName('COD_CONTA').AsInteger     := 0;
          ParamByName('COD_CONTA').Clear;
          EditaCliMemoryChave(ParamByName('COD_CHAVE').AsInteger ,0);
        end
        else
        begin
          ParamByName('COD_CATEGORIA').AsInteger   := CliMemoryCOD_CATEGORIA.AsInteger;
          ParamByName('COD_SUBCATEGORIA').AsInteger:= CliMemoryCOD_SUBCATEGORIA.AsInteger;
          ParamByName('COD_CHAVE').AsInteger       := 0;
          ParamByName('COD_CHAVE').Clear;
          ParamByName('COD_CHAVE_MOV_CTA').AsInteger := DMTabelaX.RetornaProxCodChaveMovCta;
          ParamByName('DES_OBSERVACAO').AsString   := CliMemoryDES_OBSERVACAO.AsString;
          (*Somente se a SubCategoria possuir conta contábil vinculada a mesma*)
          if CliMemoryCOD_CONTA.AsInteger > 0 then
            ParamByName('COD_CONTA').AsInteger     := CliMemoryCOD_CONTA.AsInteger
          else
          begin
            ParamByName('COD_CONTA').AsInteger     := 0;
            ParamByName('COD_CONTA').Clear;
          end;

          EditaCliMemoryChave(0,ParamByName('COD_CHAVE_MOV_CTA').AsInteger);
        end;
        ParamByName('FLG_FLUXO').AsString          := CliMemoryFLG_FLUXO.AsString;
        ParamByName('NUM_REGISTRO').AsInteger      := DMTabelaX.RetornaProxNUM_REGISTRO_MOVBCO;
        ExecSQL;
        Result := ParamByName('NUM_REGISTRO').AsInteger;
      end;
    end;
  finally
    CliMemTit.Filter := '';
    CliMemTit.Filtered := False;
    CliMemEv.Filter := '';
    CliMemEv.Filtered := False;
  end;
end;