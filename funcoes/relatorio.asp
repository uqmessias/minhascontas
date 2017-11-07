
<%
if request.QueryString("relatorio")="ok" then
 dim receber,pagar,mes
 if request.QueryString("mes")<>"" then
local = Server.MapPath("contas.mdb")
set bd = Server.CreateObject("adodb.connection")
	bd.open "dbq="&local&";Driver={Microsoft Access Driver (*.mdb)};"

sql = "select * from contas where mes='"&request.QueryString("mes")&"'"
set rs = bd.execute(sql)
set fso = Server.CreateObject("Scripting.FileSystemObject")
set arquivo = fso.OpenTextFile(Server.MapPath(replace(request.QueryString("arquivo"),"'","")),8,true)
if rs.eof= false then

arquivo.writeLine "Nome:                    receber:		pagar:"
arquivo.writeLine ""
absoluto = 0
do while rs.eof = false
absoluto = absoluto + rs("total")
tam = len(rs("nome"))
if tam<24 then
branco = ""
for i=0 to 24-(tam-1)
branco = branco&" "
next
rs_nome = rs("nome")&branco
else
rs_nome = rs("nome")&" "
end if
select case rs("mes")
case 1
	rs_mes = "Janeiro"
case 2
	rs_mes = "Fevereiro"
case 3
	rs_mes = "Março"
case 4
	rs_mes = "Abril"
case 5
	rs_mes = "Maio"
case 6
	rs_mes = "Junho"
case 7
	rs_mes = "Julho"
case 8
	rs_mes = "Agosto"
case 9
	rs_mes = "Setembro"
case 10
	rs_mes = "Outubro"
case 11
	rs_mes = "Novembro"
case 12
	rs_mes = "Dezembro"
end select
	arquivo.writeLine rs_nome&rs("receber")&"			"&rs("pagar")
rs.movenext
loop 

arquivo.writeLine ""
arquivo.writeLine ""
arquivo.writeLine "Mês:		"&rs_mes
arquivo.writeLine "Total:	"&absoluto
arquivo.close
set arquivo= nothing
set fso = nothing
bd.close
set bd = nothing
end if
end if
end if%>