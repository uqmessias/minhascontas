<%application("path") = Replace(Server.MapPath("exemplificando"), "exemplificando", "") %><html>
<head>
<title>Uilque Messias - Minhas Contas - UMMoney - Gerenciador de Contas </title>
<link rel="stylesheet" href="css/default.css" type="text/css" />
<link rel="shortcut icon" href="img/money.png" type="image/png" />
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/dragdrop.js"></script>
<script type="text/javascript" src="js/funcoes.js"></script>
<script type="text/javascript">
    window.onload = function () {
        dragdrop("mover", "addConta");
        Ajax('cmd=mostrar&mes=<%=month(now)%>');
        Funcoes.zerar();
        ID('pagar').onkeyup = ID('receber').onkeyup = total;
        ID('login').onkeyup = ID('senha').onkeyup = ID('clickLogin').onclick = function (ev) {
            var e = (ev) ? ev : window.event, chr = (e.keyCode) ? e.keyCode : e.which;
            if (e.type == 'click' || chr == 13)
                login();
        }
    }
</script>
</head>
<body>
<div id="todo">
    <div id="divLogin">
        <h3>Efetue o login para continuar</h3>
        <p>Login: <input type="text" id="login" /></p>
        <p>Senha: <input type="password" id="senha" /></p>
        <input type="button" value="Entrar" id="clickLogin" />
        
    </div>
</div>
<h1 style="color:silver">UMMoney - Gerenciador de Contas</h1>
<div id="addConta" style="position:absolute;top:20px;left:400px;display:none;background:white;">
<span style="position:absolute;top:0px;left:0px;height:25px;width:250px;" id="mover"></span><table style="border:1px solid gray">
  
	<tr> <td>&nbsp;</td><td align="right"><input type="image"  src="img/x.png" style="height:32px;width:32px;z-index:99;" onclick="ID('addConta').style.display='none';"/></td> </tr>
	<tr>
		<th> Nome:</th>
		<td><input name="text" type="text" id="nome" title="Coloque aqui o nome de quem você deve ou de quem te deve!" /></td>
	</tr>
	<tr>
		<th>Pagar:</th>
		<td><input name="text2" type="text" id="pagar" title="Coloque aqui o valor que você vai pagar(Valor Numérico)" value="0" /></td>
	</tr>
	<tr>
		<th>Receber:</th>
		<td><input name="text2" type="text" id="receber" title="Coloque aqui o valor que você vai receber(Valor Numérico)" value="0" /></td>    

	</tr>
	<tr>
		<th>M&ecirc;s:
		  <br></th>
		 <td><select name="select" id="mes">
          <option value="<%=month(now)%>"><%=monthName(month(now))%></option>
          <option value="1">Janeiro</option>
          <option value="2">Fevereiro</option>
          <option value="3">Março</option>
          <option value="4">Abril</option>
          <option value="5">Maio</option>
          <option value="6">Junho</option>
          <option value="7">Julho</option>
          <option value="8">Agosto</option>
          <option value="9">Setembro</option>
          <option value="10">Outubro</option>
          <option value="11">Novembro</option>
          <option value="12">Dezembro</option>
        </select><br></td>
		
	</tr>
	<tr>
		<th>Informa&ccedil;&otilde;es:
		  <br></th>
		<td><textarea id="info" rows="5" cols="30"></textarea></td>
	</tr>
	<tr>	
		<th>Total:<br><br></th>
		<td><input name="text2" type="text" id="total" style="border:0px;font-weight:bold;font-size:15px;" value='0' size="10" readonly="readonly" /><br><br></td>
	</tr>	  
	<tr>
		<td colspan="2" align="center">
			<input type="button" value="Adicionar" id="NovaConta" onclick="Funcoes.novaConta();" style="color:green;border:1px solid gray;" />
		</td>
	</tr>
        
</table></div>
 <div id="mostrar" style="height:300px;width:100%;overflow:visible;"></div>
 <div onclick="ID(this.id).style.display='none'" id="opcoes"></div>
 <div id="alerta"></div>




</center>
</body>
</html>