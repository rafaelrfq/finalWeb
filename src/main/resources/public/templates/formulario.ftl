
<!DOCTYPE html>
<html lang="en"  manifest="/templates/sinconexion.appcache"><!--manifest="/templates/sinconexion.appcache"-->
<head>
    <meta charset="UTF-8">
    <title>Cliente HTML5</title>
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <script src="/templates/js/offline.min.js"></script>
    <link href="/templates/css/bootstrap.css" rel="stylesheet">
    <link href="css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="/templates/css/offline-theme-chrome.css" />
    <link rel="stylesheet" href="/templates/css/offline-language-spanish.css" />
    <link rel="stylesheet" href="/templates/css/offline-language-spanish-indicator.css" />
    <link rel='stylesheet' href='/templates/css/webcam-demo.css' >
    <link rel='stylesheet' href='css/webcam-demo.css' >
    <link rel="icon" href="data:;base64,iVBORw0KGgo=">

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
    <script type="text/javascript" src="/templates/js/jquery-3.5.1.slim.min.js"></script>
    <script type="text/javascript" src="js/jquery-3.5.1.slim.min.js"></script>
    <script type="text/javascript" src="/templates/js/bootstrap.js"></script>
    <script type="text/javascript" src="js/bootstrap.js"></script>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>

    <script src="/templates/dist/webcam-easy.min.js"></script>
    <script src="dist/webcam-easy.min.js"></script>



</head>



<script>
        //dependiendo el navegador busco la referencia del objeto.
        var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB || window.moz_indexedDB

        //indicamos el nombre y la versión
        var dataBase = indexedDB.open("parcial2", 1);

        var imagen;

        //se ejecuta la primera vez que se crea la estructura
        //o se cambia la versión de la base de datos.
        dataBase.onupgradeneeded = function (e) {
            console.log("Creando la estructura de la tabla");

            //obteniendo la conexión activa
            active = dataBase.result;

            //creando la colección:
            //En este caso, la colección, tendrá un ID autogenerado.
            var formularios = active.createObjectStore("formularios", { keyPath : 'id', autoIncrement : true });

            //creando los indices. (Dado por el nombre, campo y opciones)
            formularios.createIndex('por_id', 'id', {unique: true});

            var usuario = active.createObjectStore("usuario", { keyPath : 'user', autoIncrement : false });
            //creando los indices. (Dado por el nombre, campo y opciones)
            usuario.createIndex('por_user', 'user', {unique : true});
        };

        //El evento que se dispara una vez, lo
        dataBase.onsuccess = function (e) {
            console.log('Proceso ejecutado de forma correctamente');
        };

        dataBase.onerror = function (e) {
            console.error('Error en el proceso: '+e.target.errorCode);
        };


        function agregarFormulario() {
            var dbActiva = dataBase.result; //Nos retorna una referencia al IDBDatabase.

            //Para realizar una operación de agreagr, actualización o borrar.
            // Es necesario abrir una transacción e indicar un modo: readonly, readwrite y versionchange
            var transaccion = dbActiva.transaction(["formularios"], "readwrite");

            //Manejando los errores.
            transaccion.onerror = () => {
                alert(request.error.name + '\n\n' + request.error.message);
            };

            transaccion.oncomplete = () => {
                document.querySelector("#nombre").value = '';
                alert('Objeto agregado correctamente');
            };

            //abriendo la colección de datos que estaremos usando.
            var formularios = transaccion.objectStore("formularios");

            //Para agregar se puede usar add o put, el add requiere que no exista
            // el objeto.
            let temp = {
                nombre: document.querySelector("#nombre").value,
                sector: document.querySelector("#sector").value,
                nivelEscolar: document.querySelector("#nivelEscolar").value,
                latitud: document.querySelector("#latitud").value,
                longitud: document.querySelector("#longitud").value
            }

            var request = formularios.put(temp);

            request.onerror = function (e) {
                var mensaje = "Error: "+e.target.errorCode;
                console.error(mensaje);
                alert(mensaje)
            };

            request.onsuccess = () => {
                console.log("Datos Procesado con exito");
                document.querySelector("#nombre").value = "";
                document.querySelector("#sector").value = "";
                document.querySelector("#nivelEscolar").value = "";
                document.querySelector("#latitud").value = "";
                document.querySelector("#longitud").value = "";
                setearLocalizacion();
                listarDatos();
            };
        }

        function editarFormulario(idFormulario) {

            console.log("ID recibido: " + idFormulario);

            //abriendo la transacción en modo escritura.
            const transaccion = dataBase.result.transaction(["formularios"],"readwrite");
            const formularios = transaccion.objectStore("formularios");
            const requestEdicion = formularios.get(idFormulario);

            //buscando formulario por la referencia al key.
            requestEdicion.onsuccess = () => {

                let resultado = requestEdicion.result;
                console.log("los datos: "+JSON.stringify(resultado));

                if(resultado !== undefined){

                    document.querySelector("#nombre").value = resultado.nombre;
                    document.querySelector("#sector").value = resultado.sector;
                    document.querySelector("#nivelEscolar").value = resultado.nivelEscolar;
                    document.querySelector("#latitud").value = resultado.latitud;
                    document.querySelector("#longitud").value = resultado.longitud;
                    borrarFormulario(idFormulario);
                }else{
                    console.log("Formulario no encontrado...");
                }
            };
        }

        /**
         * Permite listar todos los datos digitados.
         */
        function listarDatos() {
            //por defecto si no lo indico el tipo de transacción será readonly
            var data = dataBase.result.transaction(["formularios"]);
            var formularios = data.objectStore("formularios");
            var contador = 0;
            var formularios_recuperados=[];

            //abriendo el cursor.
            formularios.openCursor().onsuccess=function(e) {
                //recuperando la posicion del cursor
                var cursor = e.target.result;
                if(cursor){
                    contador++;
                    //recuperando el objeto.
                    formularios_recuperados.push(cursor.value);
                    console.log(JSON.stringify(cursor.value));

                    //Función que permite seguir recorriendo el cursor.
                    cursor.continue();

                }else {
                    console.log("La cantidad de registros recuperados es: "+formularios_recuperados.length);
                }
            };

            //Una vez que se realiza la operación llamo la impresión.
            data.oncomplete = function () {
                imprimirTabla(formularios_recuperados);
            }
        }

        /**
         *
         * @param lista_formularios
         */
        function imprimirTabla(lista_formularios) {
            //creando la tabla...
            var tabla = document.createElement("table");
            tabla.setAttribute('class', 'table table-bordered')
            var filaTabla = tabla.insertRow();
            filaTabla.setAttribute("class","thead-dark")
            filaTabla.insertCell().textContent = "Nombre";
            filaTabla.insertCell().textContent = "Sector";
            filaTabla.insertCell().textContent = "Nivel Escolar";
            filaTabla.insertCell().textContent = "Latitud";
            filaTabla.insertCell().textContent = "Longitud";
            filaTabla.insertCell().textContent = "Acciones";

            for (var key in lista_formularios) {
                //
                filaTabla = tabla.insertRow();
                filaTabla.insertCell().textContent = ""+lista_formularios[key].nombre;
                filaTabla.insertCell().textContent = ""+lista_formularios[key].sector;
                filaTabla.insertCell().textContent = ""+lista_formularios[key].nivelEscolar;
                filaTabla.insertCell().textContent = ""+lista_formularios[key].latitud;
                filaTabla.insertCell().textContent = ""+lista_formularios[key].longitud;
                var btnEliminar = document.createElement('input');
                btnEliminar.setAttribute('class', 'btn btn-outline-danger')
                btnEliminar.setAttribute('type', 'button');
                btnEliminar.setAttribute('value', 'Eliminar');
                btnEliminar.setAttribute('onclick', 'borrarFormulario(' + lista_formularios[key].id + ')');
                var btnEditar = document.createElement('input');
                btnEditar.setAttribute('class', 'btn btn-outline-primary')
                btnEditar.setAttribute('type', 'button');
                btnEditar.setAttribute('value', 'Editar');
                btnEditar.setAttribute('onclick', 'editarFormulario(' + lista_formularios[key].id + ')');
                filaTabla.insertCell().append(btnEditar, btnEliminar);
            }

            document.getElementById("listaFormularios").innerHTML="";
            document.getElementById("listaFormularios").appendChild(tabla);
        }

        function borrarFormulario(idFormulario) {
            console.log("ID enviado: " + idFormulario);

            var data = dataBase.result.transaction(["formularios"], "readwrite");
            var formularios = data.objectStore("formularios");

            formularios.delete(idFormulario).onsuccess = function (e) {
                console.log("Formulario eliminado...");
                listarDatos();
            };
        }




        // Parte de WebSocket

        var webSocket;
        var tiempoReconectar = 5000;

        $(document).ready(function(){
            console.info("Iniciando Jquery -  Ejemplo WebServices");

            conectar();

            $("#boton").click(function(){

                if(!webSocket || webSocket.readyState == 3) {

                    alert("Debe conectarse a internet, antes de sincronizar")

                }else{
                    let data = dataBase.result.transaction(["formularios"]);
                    let formularios = data.objectStore("formularios");

                    formularios.openCursor().onsuccess = function (e) {
                        //recuperando la posicion del cursor
                        var cursor = e.target.result;
                        if (cursor) {
                            webSocket.send(JSON.stringify(cursor.value));
                            cursor.continue();
                        } else {
                            console.log("No hay mas datos.");
                        }
                    };
                    alert("Datos sincronizados");
                    dataBase.result.deleteObjectStore("formularios");
                }
            });
        });

        /**
         *
         * @param mensaje
         */
        function recibirInformacionServidor(mensaje){
            console.log("Recibiendo del servidor: "+mensaje.data)
            $("#mensajeServidor").append(mensaje.data);
        }

        function conectar() {
            webSocket = new WebSocket("wss://" + location.hostname + ":" + location.port + "/wsMsg");
            var req = new XMLHttpRequest();
            req.timeout = 5000;
            req.open('GET', "https://" + location.hostname + ":" + location.port + "/formulario", true);
            req.send();



            //indicando los eventos:
            webSocket.onmessage = function(data){recibirInformacionServidor(data);};
            webSocket.onopen  = function(e){
                var req = new XMLHttpRequest();
                req.timeout = 5000;
                req.open('GET', "https://" + location.hostname + ":" + location.port + "/formulario", true);
                req.send();
                console.log("Conectado - status "+this.readyState); };
            webSocket.onclose = function(e){

                console.log("Desconectado - status "+this.readyState);
                var req = new XMLHttpRequest();
                req.timeout = 5000;
                req.open('GET', "https://" + location.hostname + ":" + location.port + "/formulario", true);
                req.send();
            };
        }

        function verificarConexion(){
            if(!webSocket || webSocket.readyState == 3){
                conectar();
            }
        }

        function guardarFoto() {

            let picture = document.querySelector('#download-photo').href

            imagen = window.btoa(picture);

            document.getElementById("webcam-switch").checked = false;

            var elem = document.getElementById("webcam-app")



            //Creando una objeto tipo img html
            var imgSrcs = picture   // array of URLs
            var myImages, img;
            img = new Image();
            img.onload = function() {
                    // decide which object on the page to load this image into
                    // this part of the code is missing because you haven't explained how you
                    // want it to work
                elem.style.backgroundImage = "url(" + this.src + ")";
                };
            img.src = imgSrcs;
            myImages = img;



            // var img = document.createElement("img");
            // img.file = picture;







            stopAll();
            console.log("coloco imagen");

        };

        setInterval(verificarConexion, tiempoReconectar); //para reconectar.
    </script>

</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="/"><img src="/img/logo.png" width="60" height="40" alt="Logo"></a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link active" href="/formulario">Formulario</a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="/formulario/mapa">Mapa</a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="/formulario/listado">Listado Del Formulario</a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="/login">Salir</a>
            </li>
        </ul>
    </div>
</nav>
<main type="main">
    <div class="container">
        <br><h1 class="text-center">${title}</h1><br>



        <div class="row justify-content-center">
        <div id="webcam-app" class="col-lg-10 push-lg-1 card container" style="max-height: 600px;">
            <div class="form-control webcam-start" id="webcam-control">
                <label class="form-switch">
                    <input type="checkbox" id="webcam-switch">
                    <i></i>
                    <span id="webcam-caption">Click to Start Camera</span>
                </label>
                <button id="cameraFlip" class="btn d-none"></button>
            </div>

            <div id="errorMsg" class="col-12 col-md-6 alert-danger d-none">
                Fail to start camera, please allow permision to access camera. <br/>
                If you are browsing through social media built in browsers, you would need to open the page in Sarafi (iPhone)/ Chrome (Android)
                <button id="closeError" class="btn btn-primary ml-3">OK</button>
            </div>
            <div class="md-modal md-effect-12">
                <div id="app-panel" class="app-panel md-content row p-0 m-0">
                    <div id="webcam-container" class="webcam-container col-12 d-none p-0 m-0">
                        <video id="webcam" autoplay playsinline width="640" height="480"></video>
                        <canvas id="canvas" class="d-none"></canvas>
                        <div class="flash"></div>
                        <audio id="snapSound" src="audio/snap.wav" preload = "auto"></audio>
                    </div>
                    <div id="cameraControls" class="cameraControls">
                        <a href="#" id="exit-app" title="Exit App" class="d-none"><i class="material-icons">exit_to_app</i></a>
                        <a href="#" id="take-photo" title="Take Photo"><i class="material-icons">camera_alt</i></a>
                        <a href="#" id="download-photo" title="Save Photo" onclick="guardarFoto()" class="d-none"><i class="material-icons">file_download</i></a>
                        <a href="#" id="resume-camera"  title="Resume Camera" class="d-none"><i class="material-icons">camera_front</i></a>
                    </div>
                </div>
            </div>
            <div class="md-overlay"></div>
        </div>

    </div>
        <br>


        <div class="form-group">
            <label for="nombre">Nombre:</label>
            <input class="form-control" type="text" id="nombre" name="nombre">
        </div>
        <div class="form-group">
            <label for="sector">Sector:</label>
            <input class="form-control" type="text" id="sector" name="sector">
        </div>
        <div class="form-group">
            <label for="nivelEscolar">Nivel Escolar:</label>
            <select class="form-control" name="nivelEscolar" id="nivelEscolar">
                <#list choices as choice>
                    <option value="${choice}">${choice}</option>
                </#list>
            </select>
        </div>
        <div class="form-group">
            <label for="latitud">Latitud:</label>
            <input class="form-control" type="text" id="latitud" name="latitud" readonly>
        </div>
        <div class="form-group">
            <label for="longitud">Longitud:</label>
            <input class="form-control" type="text" id="longitud" name="longitud" readonly>
        </div>
        <button class="btn btn-primary" onclick="agregarFormulario()">Salvar</button>
        <button class="btn btn-secondary" onclick="listarDatos()">Listar Datos</button>
    </div>
    <div class="container ">
        <br><button id="boton" class="btn btn-outline-success" type="button">Sincronizar Datos</button>
    </div>
    <br><br>
    <div class="container jumbotron-fluid" id="listaFormularios"></div>

    <script type="text/javascript" src="/templates/js/jquery-3.5.1.slim.min.js"></script>
    <script>
        var id, cantidad = 0;
        //Indica las opciones para llamar al GPS.
        var opcionesGPS = {
            enableHighAccuracy: true,
            timeout: 500,
            maximumAge: 0
        }

        $(document).ready(setearLocalizacion());

        function setearLocalizacion() {
            //Obteniendo la referencia directa.
            navigator.geolocation.getCurrentPosition(function(geodata){
                var coordenadas = geodata.coords;
                document.querySelector("#latitud").value = coordenadas.latitude;
                document.querySelector("#longitud").value = coordenadas.longitude;
            }, function(){
                document.querySelector("#latitud").value = "No permite el acceso del API GEO";
                document.querySelector("#longitud").value = "No permite el acceso del API GEO";
            }, opcionesGPS);

            //Obteniendo el cambio de referencia.
            id = navigator.geolocation.watchPosition(function(geodata){
                var coordenadas = geodata.coords;
                document.querySelector("#latitud").value = coordenadas.latitude;
                document.querySelector("#longitud").value = coordenadas.longitude;
                cantidad++;
                if(cantidad>=5){
                    navigator.geolocation.clearWatch(id);
                    console.log("Finalizando la trama")
                }
            },function(error){
                //recibe un objeto con dos propiedades: code y message.
                document.querySelector("#latitud").value = "No permite el acceso del API GEO. Codigo: "+error.code+", mensaje: "+error.message;
                document.querySelector("#longitud").value = "No permite el acceso del API GEO. Codigo: "+error.code+", mensaje: "+error.message;
            });
        }
    </script>
</main>
<script type="text/javascript" src="/templates/js/jquery-3.5.1.slim.min.js"></script>
<script type="text/javascript" src="js/jquery-3.5.1.slim.min.js"></script>
<script type="text/javascript" src="/templates/js/popper.min.js"></script>
<script type="text/javascript" src="/templates/js/bootstrap.js"></script>
<script>
    const webcamElement = document.getElementById('webcam');

    const canvasElement = document.getElementById('canvas');

    const snapSoundElement = document.getElementById('snapSound');

    const webcam = new Webcam(webcamElement, 'user', canvasElement, snapSoundElement);



    function stopAll(){
        cameraStopped();
        webcam.stop();
        console.log("webcam stopped");
    }

    $("#webcam-switch").change(function () {
        if(this.checked){
            $('.md-modal').addClass('md-show');
            webcam.start()
                .then(result =>{
                    removeCapture();
                    cameraStarted();
                    console.log("webcam started");
                })
                .catch(err => {
                    displayError();
                });
        }
        else {
            cameraStopped();
            webcam.stop();
            console.log("webcam stopped");
        }
    });

    $('#cameraFlip').click(function() {
        webcam.flip();
        webcam.start();
    });

    $('#closeError').click(function() {
        $("#webcam-switch").prop('checked', false).change();
    });

    function displayError(err = ''){
        if(err!=''){
            $("#errorMsg").html(err);
        }
        $("#errorMsg").removeClass("d-none");
    }

    function cameraStarted(){
        $("#errorMsg").addClass("d-none");
        $('.flash').hide();
        $("#webcam-caption").html("on");
        $("#webcam-control").removeClass("webcam-off");
        $("#webcam-control").addClass("webcam-on");
        $(".webcam-container").removeClass("d-none");
        if( webcam.webcamList.length > 1){
            $("#cameraFlip").removeClass('d-none');
        }
        $("#wpfront-scroll-top-container").addClass("d-none");
        window.scrollTo(0, 0);

    }

    function cameraStopped(){
        $("#errorMsg").addClass("d-none");
        $("#wpfront-scroll-top-container").removeClass("d-none");
        $("#webcam-control").removeClass("webcam-on");
        $("#webcam-control").addClass("webcam-off");
        $("#cameraFlip").addClass('d-none');
        $(".webcam-container").addClass("d-none");
        $("#webcam-caption").html("Click to Start Camera");
        $('.md-modal').removeClass('md-show');
    }


    $("#take-photo").click(function () {

        let picture = webcam.snap();
        document.querySelector('#download-photo').href = picture;
        afterTakePhoto();
    });

    function beforeTakePhoto(){
        $('.flash')
            .show()
            .animate({opacity: 0.3}, 500)
            .fadeOut(500)
            .css({'opacity': 0.7});
        window.scrollTo(0, 0);
        $('#webcam-control').addClass('d-none');
        $('#cameraControls').addClass('d-none');
    }

    function afterTakePhoto(){
        webcam.stop();
        $('#canvas').removeClass('d-none');
        $('#take-photo').addClass('d-none');
        $('#exit-app').removeClass('d-none');
        $('#download-photo').removeClass('d-none');
        $('#resume-camera').removeClass('d-none');
        $('#cameraControls').removeClass('d-none');
    }

    function removeCapture(){
        $('#canvas').addClass('d-none');
        $('#webcam-control').removeClass('d-none');
        $('#cameraControls').removeClass('d-none');
        $('#take-photo').removeClass('d-none');
        $('#exit-app').addClass('d-none');
        $('#download-photo').addClass('d-none');
        $('#resume-camera').addClass('d-none');
    }

    $("#resume-camera").click(function () {
        webcam.stream()
            .then(facingMode =>{
                removeCapture();
            });
    });

    $("#exit-app").click(function () {
        removeCapture();
        $("#webcam-switch").prop("checked", false).change();
    });
</script>

</body>
</html>
