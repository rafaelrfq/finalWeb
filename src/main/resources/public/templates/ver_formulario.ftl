<#include "base.ftl">

<#macro page_body>
    <div class="container text-center">
        <br><u><h1>${title}</h1></u><hr>
        <h2 class="text-center">Detalle Formulario</h2>
        <div class="card" >
            <br><h2 class="text-center">Foto del lugar</h2><br>
            <#if (formulario.mimeType)?? && (formulario.mimeType) == "placeholder" && (formulario.fotoBase64)??>
                <img src="${formulario.fotoBase64}" class="card-img-top" alt="Imagen del Formulario" width="auto" height="auto" style="height: 50%; width: 50%; display: block; margin-left: auto; margin-right: auto">
            <#elseif !(formulario.fotoBase64)??>
                <h4>Este formulario no tiene foto.</h4>
            <#elseif (formulario.mimeType)?? && (formulario.mimeType) != "placeholder" && (formulario.fotoBase64)??>
                <img src="data:${formulario.mimeType};base64,${formulario.fotoBase64}" class="card-img-top" alt="Imagen del Producto" width="auto" height="auto" style="height: 50%; width: 50%; display: block; margin-left: auto; margin-right: auto">
            </#if>
            <br>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text" id="nombre">Nombre:</span>
                        </div>
                        <input type="text" class="form-control" id="validationDefaultnombre" value="${formulario.nombre}" aria-describedby="nombre" required readonly>
                    </div>
                    </div>
                    <div class="col-md-4">

                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="sector">Sector:</span>
                            </div>
                            <input type="text" class="form-control" id="validationDefaultsector" value="${formulario.sector}" aria-describedby="sector" required readonly>
                        </div>


                    </div>
                    <div class="col-md-4">

                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="nivelEscolar">Nivel Escolar:</span>
                            </div>
                            <input type="text" class="form-control" id="validationDefaultnivelEscolar" value="${formulario.nivelEscolar}" aria-describedby="nivelEscolar" required readonly>
                        </div>

                    </div>
                </div>
                <br><br>
                <div class="row">
                    <div class="col-md-6">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="latitud">Latitud: </span>
                            </div>
                            <input type="text" class="form-control" id="validationDefaultlatitud" value="${formulario.latitud}" aria-describedby="latitud" required readonly>
                        </div>
                    </div>
                    <div class="col-md-6">


                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text" id="longitud">Longitud: </span>
                            </div>
                            <input type="text" class="form-control" id="validationDefaultlongitud" value="${formulario.longitud}" aria-describedby="longitud" required readonly>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <br><br>
        <a class="btn btn-info" href="/formulario/listado/">Volver al Listado</a>
    </div><br>
</#macro>

<@display_page/>