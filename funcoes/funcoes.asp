<!--#include file="login.asp"--><% response.Expires = -1
Response.Charset = "utf-8"
Session.LCID = 1046
Session.TimeOut = 50
Session.CodePage = 1252
on error resume next
lugar = application("path") & "contas.mdb"
set bd = Server.CreateObject("adodb.connection")
	bd.open "dbq="& lugar &";Driver={Microsoft Access Driver (*.mdb)};"
cmd = replace(request.QueryString("cmd"),"'","")
nome = replace(request.QueryString("nome"),"'","")
pagar = replace(request.QueryString("pagar"),"'","")
receber = replace(request.QueryString("receber"),"'","")
mes = replace(request.QueryString("mes"),"'","")
total = replace(request.QueryString("total"),"'","")
info = replace(request.QueryString("info"),"'","")
id = replace(request.QueryString("id"),"'","")
valor = replace(request.QueryString("valor"),"'","")
'mostrar querystrings
'for each key in Request.QueryString()
'    Response.Write key & " = "& Request.QueryString(key) & "<br/>" 
'next


If Session("login") = "Uilque" Then
    Select case cmd
    case "add"
		    response.write "<!--alertar-->"
	    if nome<>"" and pagar<>"" and receber<>"" and mes<>"" and total<>"" and info<>"" then
		    bd.execute("insert into contas (nome,pagar,receber,mes,total,info) values('" & nome &"','"&pagar&"','"&receber&"','"&mes&"',"&total&",'"&info&"')")
		    response.write "Dados inseridos com sucesso!"
	    else
		    response.write "Erro ao inserir dados!Algum campo ficou em branco!"
	    end if

    case "saldo"
		    response.write "<!--alertar-->"
	    set rs = bd.execute("select * from contas")
	    if rs.eof = false then
		    t = 0
		    do until rs.eof
		    t = t+rs("total")
		    rs.movenext
		    loop
		    if t>0 then
			    n = "POSITIVO"
		    elseif t<=0 then
			    n = "NEGATIVO"
		    end if
		    response.write "Voce esta com o saldo "&n&" de: "&replace(replace(formatCurrency(t),"(",""),")","")&"!"
	    else
		    response.write "Voce nao tem nenhuma conta registrada!"
	    end if

    case "salvar_txt"
	    response.write "<!--alertar-->"
	    if nome<>"" then
		    set rs = bd.execute("select * from contas")
		    if rs.eof= false then
			    total = 0
			    set fso = Server.CreateObject("Scripting.FileSystemObject")
			    if fso.FileExists(application("path") & "textos_salvo\"&nome) then
				    response.write "O arquivo ja existe! tente com outro nome!"
			    else
				    set t = fso.CreateTextFile(application("path") & "textos_salvo\"&nome,true,true)
				    t.writeLine "*******************************************************************************************************"
				    t.writeLine "NOME				PAGAR		RECEBER		MÊS		TOTAL		INFORMAÇÕES"
				    t.writeLine "*******************************************************************************************************"
				
					    do until rs.eof
						    total = total + rs("total")
						    l = ""
						    for i=1 to 32-len(rs("nome"))
							    l=l&" "
						    next
						    t.writeLine rs("nome")&l&rs("pagar")&"		"&rs("receber")&"		"&rs("mes")&"		"&rs("total")&"		"&rs("info")
						    rs.movenext
					    loop
					    total = "SALDO TOTAL	:	R$ "&total&",00"
				    t.writeLine "*******************************************************************************************************"
				    t.writeLine ""
				    t.writeLine ""
				    t.writeLine total
					
					    t.close
					    response.write "Texto gravado com sucesso!"
				    set t = nothing
		    end if
			    set fso = nothing
		    else
			    response.write "Voce nao tem nenhuma conta registrada!"
		    end if
	    else
		    response.write "Preencha um nome para o arquivo!"
	    end if
	
    case "atualiza"
		    response.write "<!--alertar-->"
	    if valor<>"" and nome<>"" and id<>"" and bd.execute("select * from contas where id="&id).eof=false then
			    comp = ""
		    if isnumeric(valor) = false then
			    valor = "'"&valor&"'"
		    elseif nome="pagar" then
			    bd.execute("update contas set total=receber-"&valor&" where id="&id)
		    elseif nome="receber" then
			    bd.execute("update contas set total="&valor&"-pagar where id="&id)		
		    end if
		    bd.execute("update contas set "&nome&"="&valor&""&comp&" where id="&id)
		    response.write "Campo alterado com sucesso!"
	    else
		    response.write "Erro ao alterar Campo! algum campo ficou em branco!"
	    end if
	
    case "excluir"
		    response.write "<!--alertar-->"
	    if id<>"" and bd.execute("select * from contas where id="&id).eof= false then
		    bd.execute("delete * from contas where id="&id)
		    response.write "A conta foi excluida com sucesso!"
	    else
		    response.write "Ocorreu algum erro ao exluir a conta!"
	    end if
    case "excluir_tudo"
		    response.write "<!--alertar-->"
	    if bd.execute("select * from contas").eof= false then
		    bd.execute("delete * from contas")
		    response.write "Todas as contas foram excluidas com sucesso!"
	    else
		    response.write "Ocorreu algum erro ao exluir as contas!"
	    end if
    case "mostrar"
    if mes<>"" then
	    set rs = bd.execute("select * from contas order by total")
		    response.write "<!--mostrar-->"
		    response.write "<table id=""tabela"">"
	    if rs.eof then
		    response.write "<tr><td colspan=""7"" align=""center""><b style=""color:red"">N&atilde;o existe nenhuma conta!</b></td></tr>"
	    else
		    response.write "<tr style=""border-left:1px solid gray;border-right:1px solid red;""><th>Nome</th><th>Pagar</th><th>Receber</th><th>total</th><th>Mes</th><th>Informa&ccedil;&otilde;es</th><th style=""text-align:center;font-weight:bold;font-size:12px;"" onclick=""Funcoes.excluirTudo()"" colspan=""6"" title=""Excluir todas contas""><img src='img/x.png' style='border:none;cursor:pointer;' alt='excluir todas' /></th></tr>"
		    n = 0
		    do until rs.eof
			    n= n+1
			    estilo = " style=""background:#eaeaea;"""
			    if len(replace(replace(n/2,".",""),",",""))<len(n/2) then
				    estilo = " style=""background:#cdcdcd;"""
			    end if
			    response.write "<tr"&estilo&" class='todastr'><td style=""font-weight:bold;font-size:13px;"" id=""nome"&n&""" ondblclick=""Funcoes.inicioEdicaoCampo(this, " & rs("id") & ", 'nome')"" title=""Nome da Conta"">"&Server.HTMLencode(rs("nome"))&"</td>"
			    response.write "<td id=""pagar"&n&""" ondblclick=""Funcoes.inicioEdicaoCampo(this, " & rs("id") & ", 'pagar')"" title=""Pagar"">"&Server.HTMLencode(rs("pagar"))&"</td>"
			    response.write "<td id=""receber"&n&""" ondblclick=""Funcoes.inicioEdicaoCampo(this, " & rs("id") & ", 'receber')"" title=""Receber"">"&Server.HTMLencode(rs("receber"))&"</td>"
			    response.write "<td id=""total"&n&""" title=""Total"">"&rs("total")&"</td>"			
			    response.write "<td id=""mes"&n&""" ondblclick=""Funcoes.inicioEdicaoCampo(this, " & rs("id") & ", 'mes')"" title=""M&ecirc;s"">"&rs("mes")&"</td>"
			    response.write "<td id=""info"&n&""" ondblclick=""Funcoes.inicioEdicaoCampo(this, " & rs("id") & ", 'info')"" title=""Informa&ccedil;&otilde;es"">"&Server.HTMLencode(rs("info"))&"</td>"
			    response.write "<td style=""text-align:center;font-weight:bold;font-size:12px;"" onclick=""Funcoes.excluir("&rs("id")&")"" colspan=""6"" title=""Excluir conta""><img src='img/x.png' style='border:none;cursor:pointer;' alt='excluir conta' /></td></tr>"
			    rs.movenext
				
		    loop
		
	    end if
	    response.write "<tr><td style=""text-align:center;font-weight:bold;color:green;"" colspan=""6""><a href=""javascript:void(0);"" id=""NovaConta"" onclick=""ID('addConta', {style: {display: 'block'}});fade('addConta');"">Adicionar Novo</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=""javascript:void(0);"" onclick=""Funcoes.opcoes(event,'"&Server.URLEncode(application("path") & "textos_salvo\")&"')"" title=""Op&ccedil;&otilde;es"">Op&ccedil;&otilde;es</a> &nbsp;&nbsp;&nbsp;<a href='javascript:VOID(\'Sair\')' onclick='sair()' title='Sair'>Sair</a></td></tr>"
	    response.write "</table>"
    end if
end select
Else
    Response.Write "<!--NaoAutorizado-->"
End If
set rs = nothing
bd.close
set bd = nothing
%>