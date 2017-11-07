//by tmferreira - http://www.webly.com.br/tutorial/javascript-e-ajax/7045/drag-and-drop.htm

var objSelecionado = mouseOffset = resize = HW = null;
document.onmousemove = function (ev) {
    var ev = ev || window.event;
    var mousePos = mouseCoords(ev);
    if (objSelecionado) {
        ID(objSelecionado).style.left = mousePos.x - mouseOffset.x + 'px';
        ID(objSelecionado).style.top = mousePos.y - mouseOffset.y + 'px';
        ID(objSelecionado).style.margin = '0px';
        return false;
    }
}
function addEvent(obj, evType, fn) { //Função adaptada da original de Christian Heilmann, em http://www.onlinetools.org/articles/unobtrusivejavascript/chapter4.html
    if (typeof obj == "string") {
        if (null == (obj = ID(obj))) {
            throw new Error("Elemento HTML não encontrado. Não foi possível adicionar o evento.");
        }
    }
    if (obj.attachEvent) {
        return obj.attachEvent(("on" + evType), fn);
    } else if (obj.addEventListener) {
        return obj.addEventListener(evType, fn, true);
    } else {
        throw new Error("Seu browser não suporta adição de  eventos.");
    }
}

//Função resize inicio
function resizer(id, idResize) {
    /*var obj=idResize;
    if(typeof idResize=='string')obj=$(idResize);
    if(typeof id!='string')id=id.id;
    if(obj)addEvent(obj,'mousedown',function(ev){resize=id;HW=getHW(resize,ev)});else alerta('erro no id '+idResize+' n&atilde;o existe!',3,'erro id fun&cceild;&atilde;o resizer');*/
}
function getHW(e, ev) {
    e = ID(e);
    var width, height, coords = mouseCoords(ev), pos = getPosition(e, ev);
    return { w: coords.x - pos.x, h: coords.y - pos.y };
}
//Função resize final

function mouseCoords(ev) {
    if (ev.pageX || ev.pageY) {
        return { x: ev.pageX, y: ev.pageY };
    }
    return {
        x: ev.clientX + document.body.scrollLeft - document.body.clientLeft,
        y: ev.clientY + document.body.scrollTop - document.body.clientTop
    };
}

function getPosition(e, ev) {
    e = ID(e);
    var left = 0;
    var top = 0;
    var coords = mouseCoords(ev);
    while (e.offsetParent) {
        left += e.offsetLeft;
        top += e.offsetTop;
        e = e.offsetParent;
    }
    left += e.offsetLeft;
    top += e.offsetTop;
    return { x: coords.x - left, y: coords.y - top };
}

document.onmouseup = function () {
    objSelecionado = null;
    resize = null;
}
var dragdrop = function (clique, mover) {
    if (!mover || mover == undefined) mover = clique;
    clique = document.getElementById(clique)
    ID(clique, { style: { cursor: 'move'} });
    addEvent(clique, 'mousedown', function (ev) { objSelecionado = mover; mouseOffset = getPosition(objSelecionado, ev); });
},

//Função para pegar um objeto apartir de um id e/ou extender esse objeto
ID = function (id, settings) {
    //Verificando se é um objeto ou uma string (id)
    var obj = (typeof id == 'string') ? document.getElementById(id) : id;

    //Função/método para extender o objeto
    this.extender = Object.extender = function (obj, settings) {
        var i, j;
        for (i in settings) {
            try {
                if (i != 'style') {
                    obj[i] = settings[i];
                    if (i == 'disabled' && settings[i] == 'false')
                        obj.removeAttribute(i);
                }
                else {
                    for (j in settings[i]) {
                        obj[i][j] = settings[i][j];
                    }
                }
            }
            catch (e) { }
        }
        return obj;
    }

    //Extendendo o objeto
    this.extender(obj, settings);
    return obj;
},
createObj = function (tag, settings) {
    var res = document.createElement(tag);
    ID(res, settings);
    return res;
};