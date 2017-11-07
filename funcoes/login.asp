<%
login = Request.QueryString("login")
senha = Request.QueryString("senha")
if login = "uilquegb" and senha = "messias" then
	Session("login") = "Uilque"
	Response.Write "<!--Autorizado-->"
elseif login = "sair" then
	Session("login") = null
	Response.Write "<!--Autorizado-->"
elseif login<>"" and senha<>"" then
	Response.Write "<!--alertar-->"
	Response.Write "Login e/ou Senhas incorretas"
End if
%>