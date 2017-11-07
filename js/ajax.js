//Função Ajax
function Ajax(url, atualizar, funcao) {
    var req = null;

    //Função para iniciar o ajax
    this.init = function () {
        try {
            req = new XMLHttpRequest();
        }
        catch (e) {
            try {
                req = new ActiveXObject("Msxml2.XMLHTTP");
            }
            catch (e) {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }
        }
    }

    //Iniciando o ajax
    this.init();

    //Caso o ajax não seja suportado pelo browser
    if (!req){
        alert("Desculpe, mas o seu navegador não suporta AJAX!");
        return false;
    }

    //Iniciar requizição ajax
    req.atualizar = atualizar;
    req.onreadystatechange = function () {
        if (this.atualizar)
            ID("mostrar", { innerHTML: "<div id='carregando'><img src='img/carregando.gif' height='30' width='30'>&nbsp;&nbsp;&nbsp;<span style='color:gray;font-size:15px;'>Carregando...</span></div>" });

        //caso a página esteja OK
        if (this.readyState == 4) {
            if (this.responseText.indexOf("<!--NaoAutorizado-->") != -1) {
                ID("todo", { style: { display: 'block'} });
                ID('login').focus();

                //Caso seja pra alertar algo
            } else if (this.responseText.indexOf("<!--Autorizado-->") != -1) {
                window.location.reload();

                //Caso seja pra alertar algo
            }
            //caso a resposta do servidor seja positiva
            if (this.status == 200) {
                if (funcao && typeof funcao == 'function')
                    funcao(this.responseText);
                //Caso seja pra mostrar o conteúdo na tela
                if (this.responseText.indexOf("<!--mostrar-->") != -1) {
                    ID("mostrar", { innerHTML: this.responseText });

                    //Caso não esteja autorizado
                } else if (this.responseText.indexOf("<!--alertar-->") != -1) {
                    Ajax("cmd=mostrar&mes=10", true);
                    var response = this.responseText.replace("<!--alertar-->", "");
                    alertar(response);
                }

                //caso ocorra erro no servidor
            } else {
                alert("Desculpe!\nMas ocorreu um erro no Servidor Interno!\nURL: " + this.url);
                ID("mostrar", { innerHTML: this.responseText });
            }
        }
    }
    url = req.url = (url) ? url : '';
    url = req.url = "funcoes/funcoes.asp?" + url;
    req.open("GET",  url, true);
    req.send(null);
}