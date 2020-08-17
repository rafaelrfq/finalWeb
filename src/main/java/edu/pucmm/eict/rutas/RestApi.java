package edu.pucmm.eict.rutas;

import edu.pucmm.eict.controladora.FormularioServicios;
import edu.pucmm.eict.logico.Formulario;
import edu.pucmm.eict.logico.FormularioJSON;
import io.javalin.Javalin;
import static io.javalin.apibuilder.ApiBuilder.*;

public class RestApi {
    private Javalin app;
    public RestApi(Javalin app) { this.app = app; }
    FormularioServicios formularios = FormularioServicios.getInstance();

    public void rutas(){
        app.routes(() -> {

            path("/api/formularios", () -> {
                after(ctx -> {
                    ctx.header("Content-Type", "application/json");
                });

                get("/", ctx -> {
                    ctx.json(formularios.ListadoCompleto());
                });

                post("/", ctx -> {
                    FormularioJSON tmp = ctx.bodyAsClass(FormularioJSON.class);
                    if(tmp.getNombre() != null && tmp.getSector() != null && tmp.getNivelEscolar() != null){
                        Formulario formulario = new Formulario(tmp.getNombre(), tmp.getSector(), tmp.getNivelEscolar(), tmp.getLatitud(), tmp.getLongitud());
                        if(formularios.findByNombre(formulario.getNombre()).isEmpty()){
                            ctx.json(formularios.crear(formulario));
                        } else ctx.json("Formulario ya existe.");
                    } else ctx.json("Transaccion fallida.");
                });
            });
        });
    }
}
