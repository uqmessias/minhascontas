var fade = function (id, vel, i) {
    if (!id || !ID(id)) {
        alert("Por favor digite um id válido!");
    } else {
        if (!i || i <= 1) {
            var i = 1;
        }
        if (!vel || vel > 200 || vel < 50) {
            vel = 100;
        }
        if (i < vel) {

            ID(id, { style: { opacity: (i * (100 / vel)) / 100, filter: "alpha(opacity =" + i * (100 / vel) + ")"} });
            i++;
            setTimeout("fade('" + id + "'," + vel + "," + i + ")", 1)
        }
    }
},
total = function(){
    var receber = ID('receber'), pagar = ID('pagar'), total = ID('total');
    total.value = (receber.value - pagar.value);
	if(isNaN(total.value) || total.value < 1)
        ID('total', {style: {color: 'red'}});
    else
        ID('total', {style: {color: 'green'}});
},
login = function (ev) {
    var login = ID('login'), senha = ID('senha');

    if (login.value == '' || senha.value == '') {
        alertar('Login e senha não podem ficar vazios');
    } else {
        Ajax('login=' + login.value + '&senha=' + senha.value);
    }
},
sair = function () {
    if (confirm('Tem certeza que deseja sair?'))
        Ajax('login=sair');

},
alertar = function(msg){
    ID('alerta', { innerHTML: msg, style: { display: 'block'} });
    fade('alerta');
    setTimeout("ID('alerta', {style: {display: 'none'}});", 4000);
},
Funcoes = {
    excluir: function (id) {
        //caso seja confirmado a exclusão
        if (confirm("Você realmente deseja excluir esta conta?")) Ajax("cmd=excluir&id=" + id, true);
        //tentando excluir
    },
    excluirTudo: function () {
        //caso seja confirmado a exclusão
        if (confirm("Você realmente deseja excluir todas as contas?")) Ajax("cmd=excluir_tudo", true);
        //tentando excluir
    },
    inicioEdicaoCampo: function (campo, numero, nome) {
        ID(campo, { numero: numero, nome: nome });
        var funcao = function (ev) {
            var e = (ev) ? ev : window.event, chr = (e.keyCode) ? e.keyCode : e.which;
            if (ev.type == 'blur' || chr == 13) {
                ID(this.campo, { innerHTML: this.value });
                Funcoes.EditarCampo(this.campo);
            }
        },
        input = createObj('input', { size: 15,
            campo: campo,
            onkeyup: funcao,
            value: campo.innerHTML,
            onblur: funcao,
            style: { fontWeigth: 'bold' }
        });
        campo.innerHTML = '';
        //Adicionando o campo de edição
        campo.appendChild(input);
        input.focus();
    },
    EditarCampo: function (campo) {
        Ajax('cmd=atualiza&valor=' + campo.innerHTML + '&id=' + campo.numero + '&nome=' + campo.nome);
    },
    novaConta: function (nome, pagar, receber, mes, total, info) {
        var nome = ID('nome').value,
        pagar = ID('pagar').value,
        receber = ID('receber').value,
        mes = ID('mes').value,
        total = ID('total').value,
        info = ID('info').value;
        if (!nome && !pagar && !receber && !mes && !total && !info) {
            ID("addConta").style.display = "block";
            return false;
        }
        if (!nome || !pagar || !receber || !mes || !total || !info) {
            alert("Algum campo está em branco!\n nenhum campo pode ficar em branco!");
        } else {
            if (isNaN(total)) {
                alert('Os campos (pagar, receber e total) devem ser numéricos');
            } else {
                Ajax("cmd=add&nome=" + nome + "&receber=" + receber + "&pagar=" + pagar + "&mes=" + mes + "&total=" + total + "&info=" + info, true);
            }
        }
    },
    opcoes: function (event, salva) {
        var btnSalva = createObj('a', { title: 'Salvar em arquivo de texto', innerHTML: 'Salvar em .TXT', salva: salva, onclick: function () { Funcoes.salvaTexto(this.salva) } }),
        btnCalcula = createObj('a', { title: 'Calcular saldo', innerHTML: 'Calcular saldo', onclick: function () { Ajax('cmd=saldo') } }),
        br = createObj('br');
        ID('opcoes', { innerHTML: '' });
        ID('opcoes').appendChild(btnSalva);
        ID('opcoes').appendChild(br);
        ID('opcoes').appendChild(btnCalcula);
        ID("opcoes", { style: { display: 'block', height: '50px', width: '150px', position: 'absolute', top: (event.clientY - 80) + 'px', left: (event.clientX + 5) + 'px'} });
        fade("opcoes");
    },
    salvaTexto: function (salva) {
        nome = prompt("Por favor!\nDigite um nome para o arquivo (sem a extensão)!", "");
        if (nome == '') {
            alert("Você precisa digitar o nome para o arquivo!");
            this.salvaTexto();
        } else if (nome != null) {
            nome += '.txt';
            ID("opcoes", { style: { display: 'none'} });
            Ajax("cmd=salvar_txt&nome=" + nome);
            open("window.location.href='down.asp?File=" + salva + nome + "&Name=" + nome + "&Syze=100'", 'nome');
        }
    },
    zerar: function () {
        ID('nome').value = '';
        ID('pagar').value = 0;
        ID('receber').value = 0;
        ID('info').value = '';
        ID('total').value = 0;
    }
}