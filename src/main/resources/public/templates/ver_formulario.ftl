<#include "base.ftl">

<#macro page_body>
    <div class="container text-center">
        <br><u><h1>${title}</h1></u><hr>
        <h2 class="text-center">Detalle Formulario</h2>
        <div class="card" >
            <#if (formulario.mimeType)?? && (formulario.mimeType) == "placeholder" && (formulario.fotoBase64)??>
                <img src="${formulario.fotoBase64}" class="card-img-top" alt="Imagen del Formulario" width="auto" height="auto" style="height: 50%; width: 50%; display: block; margin-left: auto; margin-right: auto">
            <#elseif !(formulario.fotoBase64)??>
                <h2>Este formulario no tiene foto.</h2>
            <#elseif (formulario.mimeType)?? && (formulario.mimeType) != "placeholder" && (formulario.fotoBase64)??>
                <img src="data:${formulario.mimeType};base64,${formulario.fotoBase64}" class="card-img-top" alt="Imagen del Producto" width="auto" height="auto" style="height: 50%; width: 50%; display: block; margin-left: auto; margin-right: auto">
            </#if>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-4">
                        <h4><b>Nombre:</b></h4>
                        <input type="text" value="${formulario.nombre}" readonly>
                    </div>
                    <div class="col-md-4">
                        <h4><b>Sector:</b></h4>
                        <input type="text" value="${formulario.sector}" readonly>
                    </div>
                    <div class="col-md-4">
                        <h4><b>Nivel Escolar:</b></h4>
                        <input type="text" value="${formulario.nivelEscolar}" readonly>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <h4><b>Latitud:</b></h4>
                        <input type="text" value="${formulario.latitud}" readonly>
                    </div>
                    <div class="col-md-6">
                        <h4><b>Longitud:</b></h4>
                        <input type="text" value="${formulario.longitud}" readonly>
                    </div>
                </div>
            </div>
        </div>
        <br><br>
        <a class="btn btn-info" href="/formulario/listado/">Volver al Listado</a>
    </div><br>
</#macro>

<@display_page/>